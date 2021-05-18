# frozen_string_literal: true

class Emoji
  attr_reader :characters
  attr_accessor(
    :name,
    :version,
    :category,
    :subcategory,
    :keywords,
    :tts_descriptions,
    :qualification
  )

  def initialize(
    characters:,
    version: nil,
    name: nil,
    category: nil,
    subcategory: nil,
    qualification: nil,
    keywords: {},
    tts_descriptions: {}
  )
    @characters = characters
    @version = version
    @name = name
    @category = category
    @subcategory = subcategory
    @qualification = qualification
    @keywords = keywords
    @tts_descriptions = tts_descriptions
  end

  def merge!(other)
    self.name ||= other.name
    self.version ||= other.version
    self.category ||= other.category
    self.subcategory ||= other.subcategory
    self.qualification ||= other.qualification
    self.tts_descriptions = tts_descriptions.merge(other.tts_descriptions)
    merge_keywords(other.keywords)
    self
  end

  def root_characters
    # Split on Zero-Width Joiners, or any Modifier Symbol (like skin tones).
    characters.split(/[\u200d\p{Sk}]/, 2).first
  end

  private

  def merge_keywords(others)
    (keywords.keys | others.keys).each do |locale|
      my_keywords = keywords.fetch(locale, [])
      your_keywords = others.fetch(locale, [])
      keywords[locale] = (my_keywords | your_keywords)
    end
  end
end
