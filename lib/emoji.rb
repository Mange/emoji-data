# frozen_string_literal: true

class Emoji
  attr_reader :character, :category, :subcategory, :keywords, :normalized

  def self.normalize(character)
    character.gsub(/[\ufe0e\ufe0f]/, "")
  end

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
    @normalized = Emoji.normalize(character)
  end
end
