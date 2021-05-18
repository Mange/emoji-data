# frozen_string_literal: true

require "compiler"

RSpec.describe "Integration", :slow do
  it "compiles English files correctly" do
    compiler = Compiler.new
    compiler.add_test_file(
      "cldr/tools/cldr-code/src/main/resources/org/unicode/cldr/util/data/emoji/emoji-test.txt"
    )
    compiler.add_annotation_file("cldr/common/annotations/en.xml")
    compiler.guess_missing_categories

    expect(compiler.emojis.size).to eq(4590)

    joy = compiler.emojis["😂"]
    expect(joy).to have_attributes(
      name: "face with tears of joy",
      keywords: {
        "en" => [
          "face",
          "face with tears of joy",
          "joy",
          "laugh",
          "tear"
        ]
      },
      category: "Smileys & Emotion",
      subcategory: "face-smiling",
      qualification: "fully-qualified"
    )

    bearded_medium_light = compiler.emojis["🧔🏼"]
    expect(bearded_medium_light).to have_attributes(
      name: "person: medium-light skin tone, beard",
      keywords: {},
      category: "People & Body",
      subcategory: "person",
      qualification: "fully-qualified"
    )

    flag_se = compiler.emojis["🇸🇪"]
    expect(flag_se).to have_attributes(
      name: "flag: Sweden",
      keywords: {},
      category: "Flags",
      subcategory: "country-flag",
      qualification: "fully-qualified"
    )
  end

  it "compiles many language files correctly" do
    compiler = Compiler.new
    compiler.add_test_file(
      "cldr/tools/cldr-code/src/main/resources/org/unicode/cldr/util/data/emoji/emoji-test.txt"
    )
    compiler.add_annotation_file("cldr/common/annotations/sv.xml")
    compiler.add_annotation_file("cldr/common/annotationsDerived/sv.xml")
    compiler.add_annotation_file("cldr/common/annotations/en.xml")
    compiler.add_annotation_file("cldr/common/annotationsDerived/en.xml")
    compiler.guess_missing_categories

    expect(compiler.emojis.size).to eq(4590)

    joy = compiler.emojis["😂"]
    expect(joy.keywords).to eq(
      "en" => [
        "face",
        "face with tears of joy",
        "joy",
        "laugh",
        "tear"
      ],
      "sv" => [
        "ansikte med glädjetårar",
        "glädjetårar"
      ]
    )
  end

  it "loads name, category and subcategory for everything" do
    compiler = Compiler.new
    compiler.add_test_file(
      "cldr/tools/cldr-code/src/main/resources/org/unicode/cldr/util/data/emoji/emoji-test.txt"
    )
    # Only load English annotations to keep this faster
    Dir[
      "cldr/common/annotations/en*.xml",
      "cldr/common/annotationsDerived/en*.xml"
    ].each do |filename|
      compiler.add_annotation_file(filename)
    end
    compiler.guess_missing_categories

    compiler.emojis.each_value do |emoji|
      expect(emoji).to have_value(:name)
      expect(emoji).to have_value(:category)
      expect(emoji).to have_value(:subcategory)
    end
  end

  def have_value(name)
    satisfy { |emoji|
      value = emoji.public_send(name)
      !value.nil? && value.size >= 2
    }
  end
end
