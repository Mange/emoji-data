#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "lib/character_spec"
require_relative "lib/emoji"
require_relative "lib/label_file"
require_relative "lib/annotation_file"

# Load keywords for each locale
def load_annotations(filename, emojis)
  annotation_file = AnnotationFile.new(filename)
  language = annotation_file.language
  annotation_file.each_annotation do |characters, keywords|
    emoji = emojis[characters]
    if emoji.nil?
      emoji = Emoji.new(characters: characters)
      emojis[characters] = emoji
    end

    emoji.keywords[language] ||= []
    emoji.keywords[language] |= keywords
  end
end

def add_missing_category(emoji, emojis)
  # Try to find emoji using the same base character to get category and
  # subcategory.
  # For example, if this is Fairy + ZWJ + Male (for "Male Fairy"), then pick
  # the same category and subcategory as "Fairy" is in.
  base_emoji = emojis[emoji.root_characters]

  if base_emoji && base_emoji != emoji
    emoji.category ||= base_emoji.category
    emoji.subcategory ||= base_emoji.subcategory
  end
end

# Rework table into Category > Subcategory > Emojis structure
def format_categories(emojis)
  emojis.group_by(&:category).map do |category_name, group|
    {
      name: category_name || "No category",
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

# Build emoji table
labels_file = "cldr/common/properties/labels.txt"
emojis = LabelFile.new(labels_file).read_emojis

$stderr.print "Loading annotations"
Dir[
  "cldr/common/annotations/*.xml",
  "cldr/common/annotationsDerived/*.xml",
].each do |filename|
  load_annotations(filename, emojis)
  $stderr.print "."
end
warn " Done!"

$stderr.print "Trying to determine categories… "
emojis.each_value do |emoji|
  if emoji.subcategory.nil? || emoji.category.nil?
    add_missing_category(emoji, emojis)
  end
end
warn " Done!"

document = {
  categories: format_categories(emojis.values),
}
puts JSON.pretty_generate(document)
