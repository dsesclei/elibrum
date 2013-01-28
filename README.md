Elibrum
=======

Elibrum converts webpages into ebooks. It extracts the text with Boilerpipe and builds the ebook with `ebook-convert`.

JRuby 1.9.2 or greater is required.

## Installation

Install [Calibre](http://calibre-ebook.com/) to get `ebook-convert`.

```
$ rvm install jruby
$ rvm use jruby
$ export JRUBY_OPTS=--1.9
$ gem install elibrum
```

## Usage

```
require "elibrum"

# Must be set. Usually in the following location on OS X:
Elibrum::EBOOK_CONVERT_PATH = "/Applications/calibre.app/Contents/MacOS/ebook-convert"

Elibrum::Builder.new("git_tutorials", :epub) do
	add "http://gitready.com/intermediate/2009/01/31/intro-to-rebase.html"
	add "http://gitready.com/intermediate/2009/02/13/list-remote-branches.html"
	add "http://gitready.com/advanced/2009/07/31/tig-the-ncurses-front-end-to-git.html"
end

links = []
links << "http://techcrunch.com/2013/01/25/eu-enlists-telefonica-cisco-hp-nokia-arm-and-others-to-close-the-700k-it-job-gap-in-europe/"
links << "http://techcrunch.com/2013/01/25/h265-is-approved/"
links << "http://techcrunch.com/2013/01/24/nokia-confirms-the-pure-view-was-officially-the-last-symbian-phone/"

Elibrum::Builder.new("blog_posts", [:epub, :mobi, :pdf]) do |b|
	b.title = "Some Blog Posts"
	b.author = "TechCrunch"

	b.add *links do |a|
		a.extractor = :largest_content
		a.modify do |title, text|
			title = title.split(" | ").first.strip
			text = text.split("Comments").last
			[title, text]
		end
	end
end

# Frontpage of Hacker News as an ebook!
require "ruby-hackernews"
Elibrum::Builder.new("frontpage", [:epub, :pdf]) do
	links = RubyHackernews::Entry.all.map{|e| e.link.href}.reject{|l| l[0...4] != "http"}
	add *links
end
```

## TODO

1. Add tests
1. Modify Boilerpipe to send user agent and accept a string as input (see Webpage#text)
1. Use [gae-boilerpipe](https://github.com/gregbayer/gae-boilerpipe) to make the project pure Ruby