#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"

$LOAD_PATH << File.expand_path("lib", __dir__)
require "compiler"
require "formatter"

compiler = Compiler.new

$stderr.print "Loading CLDR emoji-test file…"
compiler.add_test_file(
  "cldr/tools/java/org/unicode/cldr/util/data/emoji/emoji-test.txt"
)
warn " Done!"

$stderr.print "Loading annotations"
Dir[
  "cldr/common/annotations/*.xml",
  "cldr/common/annotationsDerived/*.xml",
].each do |filename|
  compiler.add_annotation_file(
    filename
  )
  $stderr.print "."
end
warn " Done!"

$stderr.print "Trying to determine missing categories… "
compiler.guess_missing_categories
warn " Done!"

puts JSON.pretty_generate(Formatter.new(compiler.emojis.values))
