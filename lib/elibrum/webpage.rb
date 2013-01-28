module Elibrum
	class Webpage
		attr_reader :url, :extractor

		def initialize(url, &block)
			# Delete the trailing / so that URI.join in localize_images doesn't confuse this URL for a directory
			@url = url[-1] == "/" ? url[0...-1] : url
			@modify = proc {|title, text| [title, text]}
			@extractor = CommonExtractors::ARTICLE_EXTRACTOR

			if block
				block.arity < 1 ? instance_eval(&block) : block.call(self)
			end

			@title, @text = @modify.call(title, text)
			@text = localize_images(@text)
		end

		def title
			@title ||= Nokogiri::HTML(content).xpath("//title").text
		end

		def text
			# The page is loaded both here and in Webpage#content.
			# TODO: Modify process() to accept a string as input.
			@text ||= begin
				highlighter = HTMLHighlighter.newExtractingInstance(true, false)
				highlighter.process(URL.new(@url), @extractor)
			rescue Exception => e
				# Boilerpipe does not pass along a user agent when retrieving sites, so some return a 403
				msg = "Failed to load #{@url} (#{e})"
				puts msg
				msg
			end
		end

		def extractor=(extractor_type)
			@extractor = case extractor_type
			when :article
				CommonExtractors::ARTICLE_EXTRACTOR
			when :canola
				CommonExtractors::CANOLA_EXTRACTOR
			when :default
				CommonExtractors::DEFAULT_EXTRACTOR
			when :keep_everything
				CommonExtractors::KEEP_EVERYTHING_EXTRACTOR
			when :largest_content
				CommonExtractors::LARGEST_CONTENT_EXTRACTOR
			else
				raise "Invalid extractor: #{extractor_type}"
			end
		end

		# Allows post-extraction processing of the text.
		# Useful for removing bits that the extractor accidentally included.
		def modify(&block)
			@modify = block
		end

		private

		def content
			@content ||= open(@url).read
		end

		# Download the images to a local folder so that they will appear in the ebook.
		def localize_images(html)
			noko = Nokogiri::HTML(html)
			noko.xpath("//img/@src").each do |url|
				filetype = url.value.split(".").last.split("?").first
				filename = ""
				loop do
					filename = ".images-temp/" + SecureRandom.hex + "." + filetype
					break unless File.exists?(filename)
				end

				# Convert all relative paths to absolute ones so that we can download the images.
				absolute_url = URI.join(@url, url.value).to_s

				begin
					url.value = filename
					File.open(filename, "wb") do |f|
						img = open(absolute_url).read
						f.write(img)
					end
				rescue Exception => e
					puts "Failed to load #{absolute_url} (#{e})"
				end
			end

			noko.to_html
		end
	end
end