# frozen_string_literal: true

class Emoji
  attr_reader :characters, :category, :subcategory, :keywords

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
