[.categories[].subcategories[].emojis[].version]
  | sort_by( scan("\\d+\\.\\d+") | tonumber )
  | reduce .[] as $version ({}; .[$version | tostring] += 1)
