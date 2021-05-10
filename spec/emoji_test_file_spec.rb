# frozen_string_literal: true

require "emoji_test_file"

RSpec.describe EmojiTestFile do
  include TempFileHelpers

  it "parses an emoji test file" do
    with_example_file(
      <<~TEXT
        # Generated lines from Emoji Data v13, using GenerateCldrData.java
        # group: Smileys & Emotion
        # subgroup: face-smiling
        1F600                                      ; fully-qualified     # 😀 grinning face
        # group: People & Body
        # subgroup: hand-prop
        270D FE0F                                  ; fully-qualified     # ✍️ writing hand
        270D                                       ; unqualified         # ✍ writing hand
      TEXT
    ) do |path|
      emoji_test_file = EmojiTestFile.new(path)
      emojis = emoji_test_file.each_emoji.to_a

      expect(emojis.size).to eq(3)
      expect(emojis[0]).to have_attributes(
        class: Emoji,
        characters: "😀",
        category: "Smileys & Emotion",
        subcategory: "face-smiling",
        name: "grinning face",
        qualification: "fully-qualified"
      )
      expect(emojis[1]).to have_attributes(
        class: Emoji,
        characters: "✍️",
        category: "People & Body",
        subcategory: "hand-prop",
        name: "writing hand",
        qualification: "fully-qualified"
      )
      expect(emojis[2]).to have_attributes(
        class: Emoji,
        characters: "✍",
        category: "People & Body",
        subcategory: "hand-prop",
        name: "writing hand",
        qualification: "unqualified"
      )
    end
  end
end
