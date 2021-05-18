# frozen_string_literal: true

require "emoji_test_file"

RSpec.describe EmojiTestFile do
  include TempFileHelpers

  it "parses an emoji test file" do
    # Get this test data with:
    #   grep \
    #    -E "(Format: |1F600|270D|group: |subgroup: )" \
    #    cldr/tools/cldr-code/src/main/resources/org/unicode/cldr/util/data/emoji/emoji-test.txt
    #
    # Remove the lines not needed for the test
    with_example_file(
      <<~TEXT
        # Generated lines from Emoji Data v13, using GenerateCldrData.java
        # Format: code points; status # emoji name
        # group: Smileys & Emotion
        # subgroup: face-smiling
        1F600                                                  ; fully-qualified     # 😀 E1.0 grinning face
        # group: People & Body
        # subgroup: hand-prop
        270D FE0F                                              ; fully-qualified     # ✍️ E0.7 writing hand
        270D                                                   ; unqualified         # ✍ E0.7 writing hand
      TEXT
    ) do |path|
      emoji_test_file = EmojiTestFile.new(path)
      emojis = emoji_test_file.each_emoji.to_a

      expect(emojis.size).to eq(3)
      expect(emojis[0]).to have_attributes(
        class: Emoji,
        characters: "😀",
        version: "E1.0",
        category: "Smileys & Emotion",
        subcategory: "face-smiling",
        name: "grinning face",
        qualification: "fully-qualified"
      )
      expect(emojis[1]).to have_attributes(
        class: Emoji,
        characters: "✍️",
        version: "E0.7",
        category: "People & Body",
        subcategory: "hand-prop",
        name: "writing hand",
        qualification: "fully-qualified"
      )
      expect(emojis[2]).to have_attributes(
        class: Emoji,
        characters: "✍",
        version: "E0.7",
        category: "People & Body",
        subcategory: "hand-prop",
        name: "writing hand",
        qualification: "unqualified"
      )
    end
  end
end
