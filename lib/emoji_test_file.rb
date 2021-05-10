# frozen_string_literal: true

require "emoji"

class EmojiTestFile
  def initialize(filename)
    @filename = filename
  end

  def each_emoji
    return to_enum(:each_emoji) unless block_given?

    each_line_by_category do |line, current_group, current_subgroup|
      emoji = parse_emoji_line(line, current_group, current_subgroup)
      yield emoji if emoji
    end
  end

  private

  def each_line_by_category
    group = nil
    subgroup = nil

    each_line do |line|
      if (value = comment_value("group", line))
        group = value
      elsif (value = comment_value("subgroup", line))
        subgroup = value
      else
        yield line, group, subgroup
      end
    end
  end

  def each_line
    File.open(@filename, "r") do |file|
      file.each_line do |line|
        yield line
      end
    end
  end

  def comment_value(type, line)
    prefix = "# #{type}: "
    if line.start_with?(prefix)
      line.sub(prefix, "").strip
    end
  end

  def parse_emoji_line(line, current_group, current_subgroup)
    if (matches = MATCHER.match(line))
      Emoji.new(
        category: current_group,
        subcategory: current_subgroup,
        characters: matches["characters"],
        name: matches["name"],
        qualification: matches["qualification"]
      )
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
