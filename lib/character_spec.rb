# frozen_string_literal: true

class CharacterSpec
  def self.parse(string)
    raise "Unexpected pattern" unless string[0] == "[" && string[-1] == "]"

    new(string[1, string.size - 2]).characters
  end

  attr_reader :characters

  def initialize(string)
    @characters = parse_string(string)
  end

  private
  def parse_string(string)
    state = :normal
    compound_buf = +""

    string.each_char.each_with_object([]) do |char, characters|
      if char == "-"
        state = :range
      elsif char == "{"
        state = :compound
      elsif char == "}"
        state = :normal
        characters << compound_buf
        compound_buf = +""
      elsif state == :range
        last_char = characters[-1]

        # since range starts with a characters that is already inside the
        # result, skip the first value. Else the new range we add will start
        # with a duplicate.
        next_char = last_char.succ

        range = (next_char..char).to_a
        characters.concat(range)

        state = :normal
      elsif state == :compound
        compound_buf << char
      else
        characters << char
      end
    end
  end
end
