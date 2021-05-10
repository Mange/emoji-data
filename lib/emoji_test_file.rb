# frozen_string_literal: true

require "emoji"

class EmojiTestFile
  def initialize(filename)
    @filename = filename
  end

  def each_emoji
    File.open(@filename, "r") do |file|
      current_group = nil
      current_subgroup = nil

      file.each_line do |line|
        if line.start_with?("# group: ")
          current_group = line.split(": ", 2).last.strip
        elsif line.start_with?("# subgroup: ")
          current_subgroup = line.split(": ", 2).last.strip
        elsif (matches = MATCHER.match(line))
          yield Emoji.new(
            characters: matches["characters"],
            category: current_group,
            subcategory: current_subgroup,
            name: matches["name"],
            qualification: matches["qualification"]
          )
        end
      end
    end
  end

  MATCHER = /
    # "1F48B     ; fully-qualified     # 💋 kiss mark"
    ^
    [^;]+;\s                  # "1F48B       ; "
    (?<qualification>[^\s]+)  # "fully-qualified"
    \s+\#\s+                  # "  # "
    (?<characters>[^\s]+)\s+  # "💋 "
    (?<name>.*)$              # "kiss mark"
  /x.freeze
end
