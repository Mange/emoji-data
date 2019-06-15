# frozen_string_literal: true

class Emoji
  attr_reader :characters
  attr_accessor :category, :subcategory, :keywords

  def initialize(characters:, category: nil, subcategory: nil)
    @characters = characters
    @category = category
    @subcategory = subcategory
    @keywords = {}
  end

  def root_characters
    # Split on Zero-Width Joiners, or any Modifier Symbol (like skin tones).
    characters.split(/[\u200d\p{Sk}]/, 2).first
  end
end
