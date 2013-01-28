module Elibrum
	class Builder
		def initialize(filename, formats, template=default_template, &block)
			raise "Elibrum::EBOOK_CONVERT_PATH is not defined. Put the path to ebook-convert in this constant." unless defined?(EBOOK_CONVERT_PATH)
			
			FileUtils.mkdir(".images-temp") unless File.directory?(".images-temp")
			@book = Book.new(filename, &block)
			@template = template

			[*formats].each do |format|
				build(filename, format)
			end

			FileUtils.rm_rf(".images-temp")
		end

		def build(filename, format)
			# Create an HTML file to use as the source file for conversion
			File.open(".#{filename}-temp.html", "w+") {|f| f.write(html)}
			# Documentation for ebook-convert can be found here: http://manual.calibre-ebook.com/cli/ebook-convert.html
			`#{EBOOK_CONVERT_PATH} .#{filename}-temp.html #{filename}.#{format} --title "#{@book.title}" --authors "#{@book.author}" --chapter "//h:pagebreak"`
			#FileUtils.rm(filename + "-temp.html")
		end

		private

		def html
			@html ||= begin
				template_source = File.read(@template)
				html = @book.pages.inject("") do |ret, page|
					ret += Erubis::Eruby.new(template_source).result(title: page.title, text: page.text, url: page.url)
				end
			end
		end

		def default_template
			File.expand_path("default.erb", File.dirname(__FILE__))
		end
	end
end