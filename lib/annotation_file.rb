# frozen_string_literal: true

require "nokogiri"

class AnnotationFile
  def initialize(filename)
    @document = File.open(filename) { |f| Nokogiri::XML(f) }
  end

  def language
    @language ||= @document.root.at_xpath("./identity/language")["type"]
  end

  def each_annotation
    each_annotation_element do |element|
      emoji = Emoji.new(characters: element["cp"])

      if element["type"] == "tts"
        emoji.name = element.text.strip
      else
        keywords = element.text.split(" | ")
        keywords.delete_if { |word| word == "↑↑↑" }

        emoji.keywords[language] = keywords unless keywords.empty?
      end

      yield emoji
    end
  end

  private
  def each_annotation_element
    selector = "./annotations/annotation"
    @document.root.xpath(selector).each do |element|
      yield element
    end
  end
end
