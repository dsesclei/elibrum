module Elibrum
	class Book
		attr_accessor :title, :author
		attr_reader :pages

		def initialize(filename, &block)
			@title = filename.split(/_|-/).map(&:capitalize).join(" ")
			@author = "Unknown"
			@pages = []

			block.arity < 1 ? instance_eval(&block) : block.call(self)
		end

		def add(*links, &block)
			links.each do |url|
				@pages << Webpage.new(url, &block)
			end
		end
	end
end