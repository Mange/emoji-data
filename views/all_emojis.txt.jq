# Pick up categories and all the subcategories of it, and then pick up the
# emojis. All English keywords will be added to the line as well.

.categories[] |

  # Collect category + subcategory combos
  .name as $cat |
  reduce .subcategories[] as $sub (
    [];
    # Build an array of all emojis in this subcategory
    . + (
      $sub.emojis | map(
        # emoji    category     subcategory    name     keyword | keyword | keyword
        "\(.characters)\t\($cat)\t\($sub.name // "")\t\(.name // .tts_descriptions.en // "")\t\(.keywords.en // [] | join(" | "))"
      )
    )
  ) |

  # Merge into a single string
  join("\n")
