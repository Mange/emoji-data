# Pick up categories and all the subcategories of it, and then pick up the
# emojis. All English keywords and the English TTS description will be added to
# the line as well.

reduce .categories[] as $category (
  [];
  . + (
    # Collect category + subcategory combos
    $category.name as $cat |
    reduce $category.subcategories[] as $sub (
      [];
      # Build an array of all emojis in this subcategory
      . + (
        $sub.emojis | map(
          {
            characters: .characters,
            name: (.name // .tts_descriptions.en // .keywords.en[0]),
            category_name: $cat,
            subcategory_name: $sub.name,
            en_keywords: (.keywords.en // []),
            en_tts_description: .tts_descriptions.en,
            qualification: .qualification
          }
        )
      )
    )
  )
)
