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
        {
          characters: .characters,
          name: .name,
          category_name: $cat,
          subcategory_name: $sub.name,
          en_keywords: (.keywords.en // []),
          qualification: .qualification
        }
      )
    )
  ) |

  # Merge into a single array
  flatten
