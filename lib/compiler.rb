# frozen_string_literal: true

require "emoji_test_file"
require "annotation_file"

class Compiler
  attr_reader :emojis

  def initialize
    @emojis = {}
  end

  def add_emoji(emoji)
    if (current = emojis[emoji.characters])
      current.merge!(emoji)
    else
      emojis[emoji.characters] = emoji
    end
  end

  def add_test_file(filename)
    EmojiTestFile.new(filename).each_emoji do |emoji|
      add_emoji(emoji)
    end
  end

  def add_annotation_file(filename)
    AnnotationFile.new(filename).each_annotation do |emoji|
      add_emoji(emoji)
    end
  end

  def guess_missing_categories
    emojis.each_value do |emoji|
      if emoji.subcategory.nil? || emoji.category.nil?
        guess_missing_categories_for(emoji)
      end
    end
  end

  private

  def guess_missing_categories_for(emoji)
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
end
