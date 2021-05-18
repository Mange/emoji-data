# frozen_string_literal: true

require "nokogiri"
require "emoji"

class AnnotationFile
  # Seems to be a marker in CLDR that means "Value missing" or "Needs
  # translation".
  CLDR_DUMMY_VALUE = "↑↑↑"

  def initialize(filename)
    @document = File.open(filename) { |f| Nokogiri::XML(f) }
  end

  def language
    @language ||= @document.root.at_xpath("./identity/language")["type"]
  end

  def each_annotation
    return to_enum(:each_annotation) unless block_given?

    each_annotation_element do |element|
      if element["type"] == "tts"
        read_tts(element) { |emoji| yield emoji }
      else
        read_keywords(element) { |emoji| yield emoji }
      end
    end
  end

  private

  def each_annotation_element
    selector = "./annotations/annotation"
    @document.root.xpath(selector).each do |element|
      yield element
    end
  end

  def read_tts(element)
    description = element.text.strip
    if description != CLDR_DUMMY_VALUE
      yield Emoji.new(
        characters: element["cp"],
        tts_descriptions: {language => description}
      )
    end
  end

  def read_keywords(element)
    keywords = element
      .text
      .split("|")
      .map(&:strip)
      .reject { |word| word.empty? || word == CLDR_DUMMY_VALUE }

    unless keywords.empty?
      yield Emoji.new(
        characters: element["cp"],
        keywords: {language => keywords}
      )
    end
  end
end
