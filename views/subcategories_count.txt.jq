# Pick up categories and all the subcategories of it
.categories[] |
  .name as $cat |
  reduce .subcategories[] as $sub ([]; . + ["\($cat)\t\($sub.name // "")\t\($sub.emojis | length)"]) |
  join("\n")


