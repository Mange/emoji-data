[.categories[].subcategories[].emojis[].version]
  | sort_by( scan("\\d+\\.\\d+") | tonumber )
  | reduce .[] as $version ({}; .[$version | tostring] += 1)
  | to_entries
  | map(.key as $version | .value as $count | "\($version)\t\($count)")
  | join("\n")
