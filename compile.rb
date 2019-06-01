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
$stderr.print "Loading annotations"
Dir["cldr/common/annotations/*.xml"].each do |filename|
  annotation_file = AnnotationFile.new(filename)
  language = annotation_file.language
  annotation_file.each_annotation do |character, keywords|
    normalized = Emoji.normalize(character)
    emoji = emojis[normalized]

    if emoji.nil?
      emoji = Emoji.anonymous(character)
      emojis[emoji.normalized] = emoji
    end

    emoji.keywords[language] ||= []
    emoji.keywords[language] |= keywords
  end
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
      characters: emoji.character,
      keywords: emoji.keywords,
    }
  end
end

document = {
  categories: format_categories(emojis.values),
}
puts JSON.pretty_generate(document)
