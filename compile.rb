#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "lib/character_spec"
require_relative "lib/emoji"
require_relative "lib/label_file"
require_relative "lib/annotation_file"

# Build emoji table
labels_file = "cldr/common/properties/labels.txt"
emojis = LabelFile.new(labels_file).read_emojis

# Load keywords for each locale
def load_annotations(filename, emojis)
  annotation_file = AnnotationFile.new(filename)
  language = annotation_file.language
  annotation_file.each_annotation do |characters, keywords|
    emoji = emojis[characters] || add_new_emoji(characters, emojis)

    emoji.keywords[language] ||= []
    emoji.keywords[language] |= keywords
  end
end

def add_new_emoji(characters, emojis)
  # Try to find emoji using the same base character to get category and
  # subcategory.
  # For example, if this is Fairy + ZWJ + Male (for "Male Fairy"), then pick
  # the same category and subcategory as "Fairy" is in.
  base_emoji = emojis[Emoji.root_character(characters)]
  emoji =
    if base_emoji
      Emoji.new(
        characters: characters,
        category: base_emoji.category,
        subcategory: base_emoji.subcategory,
      )
    else
      Emoji.anonymous(characters)
    end

  emojis[characters] = emoji
end

$stderr.print "Loading annotations"
Dir[
  "cldr/common/annotations/*.xml",
  "cldr/common/annotationsDerived/*.xml",
].each do |filename|
  load_annotations(filename, emojis)
  $stderr.print "."
end
warn " Done!"

# Rework table into Category > Subcategory > Emojis structure
def format_categories(emojis)
  emojis.group_by(&:category).map do |category_name, group|
    {
      name: category_name,
      subcategories: format_subcategories(group),
    }
  end
end

def format_subcategories(emojis)
  emojis.group_by(&:subcategory).map do |subcategory_name, group|
    {
      name: subcategory_name,
      emojis: format_emojis(group),
    }
  end
end

def format_emojis(emojis)
  emojis.map do |emoji|
    {
      characters: emoji.characters,
      keywords: emoji.keywords,
    }
  end
end

document = {
  categories: format_categories(emojis.values),
}
puts JSON.pretty_generate(document)
