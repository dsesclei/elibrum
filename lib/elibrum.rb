raise "Elibrum only works on JRuby at the moment." unless RUBY_PLATFORM =~ /java/

require "open-uri"
require "uri"
require "FileUtils"
require "SecureRandom"
require "erubis"
require "nokogiri"
require "java"
require "elibrum/jars/boilerpipe-1.2.0.jar"
require "elibrum/jars/nekohtml-1.9.13.jar"
require "elibrum/jars/xerces-2.9.1.jar"

java_import "de.l3s.boilerpipe.extractors.CommonExtractors"
java_import "de.l3s.boilerpipe.sax.HTMLHighlighter"
java_import "de.l3s.boilerpipe.sax.HTMLDocument"
java_import java.net.URL

require "elibrum/builder"
require "elibrum/book"
require "elibrum/webpage"