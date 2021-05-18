# frozen_string_literal: true

require "annotation_file"

RSpec.describe AnnotationFile do
  include TempFileHelpers

  it "reads an annotation XML file" do
    sample_xml = <<~XML
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

    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.language).to eq("en")
      expect(annotation.each_annotation.count).to eq(1)
    end
  end

  it "reads keywords as the specified language" do
    sample_xml = <<~XML
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

    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.each_annotation.first).to have_attributes(
        class: Emoji,
        characters: "😀",
        name: nil,
        keywords: {"en" => ["face", "grin", "grinning face"]}
      )
    end
  end

  # This seems to be a marker in CLDR for "Needs a translation". As far as I
  # can tell, it's never mixed with real words like this, but let's be careful
  # anyway.
  it "skips keywords of just arrows" do
    sample_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8" ?>
      <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
      <ldml>
        <identity>
          <version number="$Revision$"/>
          <language type="en"/>
        </identity>
        <annotations>
          <annotation cp="😀">↑↑↑ | grin | ↑↑↑</annotation>
        </annotations>
      </ldml>
    XML

    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.each_annotation.first).to have_attributes(
        class: Emoji,
        characters: "😀",
        name: nil,
        keywords: {"en" => ["grin"]}
      )
    end
  end

  it "reads TTS annotations" do
    sample_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8" ?>
      <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
      <ldml>
        <identity>
          <version number="$Revision$"/>
          <language type="en"/>
        </identity>
        <annotations>
          <annotation cp="😀" type="tts">grin</annotation>
        </annotations>
      </ldml>
    XML

    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.each_annotation.first).to have_attributes(
        class: Emoji,
        characters: "😀",
        name: nil,
        keywords: {},
        tts_descriptions: {"en" => "grin"}
      )
    end
  end

  # This seems to be a marker in CLDR for "Needs a translation"
  it "skips TTS annotations of just arrows" do
    sample_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8" ?>
      <!DOCTYPE ldml SYSTEM "../../common/dtd/ldml.dtd">
      <ldml>
        <identity>
          <version number="$Revision$"/>
          <language type="en"/>
        </identity>
        <annotations>
          <annotation cp="😀" type="tts">↑↑↑</annotation>
        </annotations>
      </ldml>
    XML

    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.each_annotation.count).to eq(0)
    end
  end
end
