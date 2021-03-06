# frozen_string_literal: true

require "formatter"
require "emoji"

RSpec.describe Formatter do
  it "formats as JSON" do
    emojis = [
      Emoji.new(
        characters: "😀",
        version: "E1.0",
        category: "Smileys & Emotion",
        subcategory: "face-smiling",
        name: "grinning face",
        qualification: "fully-qualified",
        keywords: {"en" => ["smile", "grin"]},
        tts_descriptions: {"en" => "smiling person"}
      ),
      Emoji.new(
        characters: "✍",
        version: "E0.7",
        category: "People & Body",
        subcategory: "hand-prop",
        name: "writing hand",
        qualification: "unqualified"
      )
    ]

    formatted = Formatter.new(emojis).as_json

    expect(formatted).to eq({
      "categories" => [
        {
          "name" => "Smileys & Emotion",
          "subcategories" => [
            {
              "name" => "face-smiling",
              "emojis" => [
                {
                  "characters" => "😀",
                  "version" => "E1.0",
                  "name" => "grinning face",
                  "keywords" => {"en" => ["smile", "grin"]},
                  "tts_descriptions" => {"en" => "smiling person"},
                  "qualification" => "fully-qualified"
                }
              ]
            }
          ]
        },
        {
          "name" => "People & Body",
          "subcategories" => [
            {
              "name" => "hand-prop",
              "emojis" => [
                {
                  "characters" => "✍",
                  "version" => "E0.7",
                  "name" => "writing hand",
                  "keywords" => {},
                  "tts_descriptions" => {},
                  "qualification" => "unqualified"
                }
              ]
            }
          ]
        }
      ]
    })
  end
end
