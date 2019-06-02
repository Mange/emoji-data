# frozen_string_literal: true

require "nokogiri"

class AnnotationFile
  def initialize(filename)
    @document = File.open(filename) { |f| Nokogiri::XML(f) }
  end

  def language
    @document.root.at_xpath("./identity/language")["type"]
  end

  def each_annotation
    each_annotation_element do |element|
      characters = element["cp"]

      keywords = element.text.split(" | ")
      keywords.delete_if { |word| word == "↑↑↑" }

      yield characters, keywords unless keywords.empty?
    end
  end

  private
  def each_annotation_element
    selector = './annotations/annotation[not(@type = "tts")]'
    @document.root.xpath(selector).each do |element|
      yield element
    end
  end
end
