# frozen_string_literal: true

class Emoji
  attr_reader :characters, :category, :subcategory, :keywords

  def self.root_character(characters)
    # Split on Zero-Width Joiners, or any Modifier Symbol (like skin tones).
    characters.split(/[\u200d\p{Sk}]/, 2).first
  end

  def self.anonymous(characters)
    new(
      characters: characters,
      category: nil,
      subcategory: nil,
    )
  end

  def initialize(characters:, category:, subcategory:)
    @characters = characters
    @category = category || "No category"
    @subcategory = subcategory
    @keywords = {}
  end
end
