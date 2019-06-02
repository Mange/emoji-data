# frozen_string_literal: true

class LabelFile
  def initialize(filename)
    @filename = filename
  end

  def read_emojis
    emojis = {}
    each_label_line do |line|
      emojis.merge!(build_emojis_from_line(line))
    end
    emojis
  end

  private
  def each_label_line
    File.open(@filename, "r") do |file|
      file.each_line do |line|
        yield line if line[0] != "#" && line[0] != "\n"
      end
    end
  end

  def build_emojis_from_line(line)
    character_spec, label, second_level = line.split(";").map(&:strip)
    characters = CharacterSpec.parse(character_spec)

    characters.each_with_object({}) do |character, accumulator|
      add_emoji(accumulator, character, label, second_level)
    end
  end

  def add_emoji(accumulator, character, label, second_level)
    accumulator[character] = Emoji.new(
      character: character,
      category: label,
      subcategory: second_level,
    )
  end
end
