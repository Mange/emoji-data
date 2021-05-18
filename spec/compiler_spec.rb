# frozen_string_literal: true

require "compiler"

RSpec.describe Compiler do
  include TempFileHelpers

  plain_fairy = "\u{1f9da}"
  male_fairy = "\u{1f9da}\u{200d}\u{2642}\u{fe0f}"

  it "loads emojis from test data and annotation files" do
    compiler = Compiler.new

    with_example_files(
      "test_file.txt" => <<~TEXT,
        # group: Smileys & Emotion
        # subgroup: face-smiling
        1F600                                      ; fully-qualified     # 😀 grinning face
        # group: People & Body
        # subgroup: hand-prop
        270D FE0F                                  ; fully-qualified     # ✍️ writing hand
      TEXT
      "en.xml" => <<~XML
        <?xml version="1.0" encoding="UTF-8" ?>
        <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
        <ldml>
          <identity>
            <version number="$Revision$"/>
            <language type="en"/>
          </identity>
          <annotations>
            <annotation cp="😀">face | grin | grinning face</annotation>
          </annotations>
        </ldml>
      XML
    ) do |paths|
      expect(compiler.emojis.size).to eq(0)

      compiler.add_test_file(paths["test_file.txt"])
      expect(compiler.emojis.size).to eq(2)
      expect(compiler.emojis["😀"]).to have_attributes(
        name: "grinning face",
        keywords: {}
      )

      compiler.add_annotation_file(paths["en.xml"])
      expect(compiler.emojis.size).to eq(2)
      expect(compiler.emojis["😀"]).to have_attributes(
        name: "grinning face",
        keywords: {"en" => ["face", "grin", "grinning face"]}
      )
    end
  end

  describe "#guess_missing_categories" do
    it "tries to guess category and subcategory from root characters" do
      compiler = Compiler.new

      compiler.add_emoji(
        Emoji.new(characters: male_fairy, name: "Male Fairy")
      )

      compiler.add_emoji(
        Emoji.new(
          characters: plain_fairy,
          name: "Fairy",
          category: "People",
          subcategory: "fantasy"
        )
      )

      emoji = compiler.emojis[male_fairy]
      expect(emoji).to have_attributes(category: nil, subcategory: nil)

      compiler.guess_missing_categories
      expect(emoji).to have_attributes(category: "People", subcategory: "fantasy")
    end
  end
end
