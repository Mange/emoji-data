#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"

$LOAD_PATH << File.expand_path("lib", __dir__)
require "compiler"

# Rework table into Category > Subcategory > Emojis structure
def format_categories(emojis)
  emojis.group_by(&:category).map do |category_name, group|
    {
      name: category_name || "No category",
      subcategories: format_subcategories(group)
    }
  end
end

def format_subcategories(emojis)
  emojis.group_by(&:subcategory).map do |subcategory_name, group|
    {
      name: subcategory_name,
      emojis: format_emojis(group)
    }
  end
end

def format_emojis(emojis)
  emojis.map do |emoji|
    {
      characters: emoji.characters,
      name: emoji.name,
      keywords: emoji.keywords,
      qualification: emoji.qualification
    }
  end
end

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

document = {
  categories: format_categories(compiler.emojis.values)
}
puts JSON.pretty_generate(document)
