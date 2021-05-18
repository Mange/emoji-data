# frozen_string_literal: true

require "emoji"

RSpec.describe Emoji do
  it "requires characters" do
    emoji = Emoji.new(
      characters: "😀"
    )

    expect(emoji).to have_attributes(
      characters: "😀",
      version: nil,
      name: nil,
      category: nil,
      subcategory: nil,
      qualification: nil,
      keywords: {},
      tts_descriptions: {}
    )
  end

  it "accepts optional attributes" do
    emoji = Emoji.new(
      characters: "😀",
      version: "E0.6",
      name: "grinning face",
      category: "Category",
      subcategory: "Subcategory",
      qualification: "fully-qualified",
      keywords: {"en" => ["smile", "grin"]},
      tts_descriptions: {"en" => "smiling person"}
    )

    expect(emoji).to have_attributes(
      characters: "😀",
      version: "E0.6",
      name: "grinning face",
      category: "Category",
      subcategory: "Subcategory",
      qualification: "fully-qualified",
      keywords: {"en" => ["smile", "grin"]},
      tts_descriptions: {"en" => "smiling person"}
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
      emoji_a = Emoji.new(characters: "A", category: "Letters", version: "E0.6")
      emoji_b = Emoji.new(characters: "B", subcategory: "Latin", version: "E1.0")

      emoji_a.merge!(emoji_b)

      expect(emoji_a).to have_attributes(
        characters: "A",
        version: "E0.6",
        category: "Letters",
        subcategory: "Latin",
        keywords: {}
      )

      expect(emoji_b).to have_attributes(
        characters: "B",
        version: "E1.0",
        category: nil,
        subcategory: "Latin",
        keywords: {}
      )
    end

    it "merges keywords" do
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

    it "merges tts_descriptions" do
      emoji_a = Emoji.new(
        characters: "A",
        tts_descriptions: {"en" => "letter A", "la" => "littera A"}
      )
      emoji_b = Emoji.new(
        characters: "B",
        tts_descriptions: {"en" => "letter B", "sv" => "bokstaven B"}
      )

      emoji_a.merge!(emoji_b)

      expect(emoji_a.tts_descriptions).to eq(
        "en" => "letter B",
        "la" => "littera A",
        "sv" => "bokstaven B"
      )
    end
  end
end
