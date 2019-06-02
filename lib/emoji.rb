# frozen_string_literal: true

class Emoji
  attr_reader :character, :category, :subcategory, :keywords

  def self.anonymous(character)
    new(
      character: character,
      category: nil,
      subcategory: nil,
    )
  end

  def initialize(character:, category:, subcategory:)
    @character = character
    @category = category || "No category"
    @subcategory = subcategory
    @keywords = {}
  end
end
