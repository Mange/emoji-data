# frozen_string_literal: true

require "annotation_file"

RSpec.describe AnnotationFile do
  include TempFileHelpers

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

  it "reads an annotation XML file" do
    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.language).to eq("en")
      expect(annotation.each_annotation.count).to eq(1)
    end
  end

  it "reads keywords as the specified language" do
    with_example_file(sample_xml) do |path|
      annotation = AnnotationFile.new(path)
      expect(annotation.each_annotation.first).to have_attributes(
        class: Emoji,
        characters: "😀",
        keywords: {"en" => ["face", "grin", "grinning face"]}
      )
    end
  end
end
