# frozen_string_literal: true

require "json"

class Formatter
  def initialize(emojis)
    @emojis = emojis
  end

  def as_json
    {
      "categories" => format_categories(@emojis)
    }
  end

  def to_json(*args)
    as_json.to_json(*args)
  end

  private

  def format_categories(emojis)
    emojis.group_by(&:category).map do |category_name, group|
      {
        "name" => category_name || "No category",
        "subcategories" => format_subcategories(group)
      }
    end
  end

  def format_subcategories(emojis)
    emojis.group_by(&:subcategory).map do |subcategory_name, group|
      {
        "name" => subcategory_name,
        "emojis" => format_emojis(group)
      }
    end
  end

  def format_emojis(emojis)
    emojis.map do |emoji|
      {
        "characters" => emoji.characters,
        "version" => emoji.version,
        "name" => emoji.name,
        "keywords" => emoji.keywords,
        "tts_descriptions" => emoji.tts_descriptions,
        "qualification" => emoji.qualification
      }
    end
  end
end
