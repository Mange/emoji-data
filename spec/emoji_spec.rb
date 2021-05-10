# frozen_string_literal: true

require "emoji"

RSpec.describe Emoji do
  it "requires characters" do
    emoji = Emoji.new(
      characters: "😀"
    )

    expect(emoji).to have_attributes(
      characters: "😀",
      name: nil,
      category: nil,
      subcategory: nil,
      qualification: nil,
      keywords: {}
    )
  end

  it "accepts optional attributes" do
    emoji = Emoji.new(
      characters: "😀",
      name: "grinning face",
      category: "Category",
      subcategory: "Subcategory",
      qualification: "fully-qualified",
      keywords: {"en" => ["smile", "grin"]}
    )

    expect(emoji).to have_attributes(
      characters: "😀",
      name: "grinning face",
      category: "Category",
      subcategory: "Subcategory",
      qualification: "fully-qualified",
      keywords: {"en" => ["smile", "grin"]}
    )
  end

  describe "#root_characters" do
    it "removes Zero-Width Joiners" do
      emoji = Emoji.new(characters: "\u{1f9da}\u{200d}\u{2642}\u{fe0f}") # Male Fairy
      expect(emoji.root_characters).to eq("\u{1f9da}") # Fairy
    end

    it "removes modifier symbols" do
      emoji = Emoji.new(characters: "\u{1f44d}\u{1f3fd}") # 👍🏽
      expect(emoji.root_characters).to eq("\u{1f44d}") # 👍
    end
  end

  describe "#merge!" do
    it "assigns missing fields from the other" do
      emoji_a = Emoji.new(characters: "A", category: "Letters")
      emoji_b = Emoji.new(characters: "B", subcategory: "Latin")

      emoji_a.merge!(emoji_b)

      expect(emoji_a).to have_attributes(
        characters: "A",
        category: "Letters",
        subcategory: "Latin",
        keywords: {}
      )

      expect(emoji_b).to have_attributes(
        characters: "B",
        category: nil,
        subcategory: "Latin",
        keywords: {}
      )
    end

    it "merge keywords" do
      emoji_a = Emoji.new(
        characters: "A",
        keywords: {"en" => ["1", "2"]}
      )
      emoji_b = Emoji.new(
        characters: "B",
        keywords: {"en" => ["2", "3"], "sv" => ["10"]}
      )

      emoji_a.merge!(emoji_b)

      expect(emoji_a.keywords).to eq(
        "en" => ["1", "2", "3"],
        "sv" => ["10"]
      )
    end
  end
end
