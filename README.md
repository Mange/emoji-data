# emoji-data

Machine-readable data files for emojis.

## Motivation, or What makes this different?

I got tired of never being able to find good reference material to use when
dealing with emojis. I want data that is:

1. Easy to update when new versions of Unicode comes out.
2. Maintained as close as possible to the source (Unicode Consortium).
3. Machine-readable in multiple formats.
4. Contains keywords / alternative names of an emoji.

I could not find any good places where all these conditions are true, so I
decided to make one myself.

## Implementation

This repo adds the official Unicode [CLDR (Common Locale Data
Repository)][cldr] data files as a submodule and then builds the data files
from the contents of those files.

Data files are built by the user when they are needed to avoid having this repo
become very large and to decrease churn of files. Still, pre-built releases are
provided via GitHub for those that only want to download the finished product.

## Usage

**tl;dr:** `make all`

### Dependencies

In order to build the data files, you'll need:

1. Ruby (2.5 or later).
2. `jq` command-line JSON processor.
3. The `nokogiri` Ruby gem, which is installed automatically when needed.

You can check your dependencies by running `make setup`. It will also install
the Ruby gems that are missing.

### Generating the data

Run `make` (or `make all`) to build all data files. You can rerun this as often
as you want; only outdated files will be rebuilt.

### List of views

Here are the current views, and an example of how they look like.

### `all_emojis.json`

An JSON array of all emojis as objects with the following keys:

* `characters` - **String**. The Unicode characters that make up the emoji.
* `category_name` - **String**. The name of the category the emoji resides in.
* `subcategory_name` - **String | `null`**. The name of the subcategory the
  emoji resides in.
* `en_keywords` - **Array<String>**. List of English keywords for the emoji.

#### Sample

```json
[
  {
    "characters": "😂",
    "category_name": "Smileys & People",
    "subcategory_name": "face-positive",
    "en_keywords": [
      "face",
      "face with tears of joy",
      "joy",
      "laugh",
      "tear"
    ]
  },
  {
    "characters": "😃",
    "category_name": "Smileys & People",
    "subcategory_name": "face-positive",
    "en_keywords": [
      "face",
      "grinning face with big eyes",
      "mouth",
      "open",
      "smile"
    ]
  }
]
```

### `all_emojis.txt`

A tab-separated text file with one emoji on each line. Keywords are joined with
pipes (`|`) in the last column.

Columns are, in order:

* `characters` - The Unicode characters that make up the emoji.
* `category_name` - The name of the category the emoji resides in.
* `subcategory_name` - The name of the subcategory the emoji resides in. Can be
  empty.
* `en_keywords` - List of English keywords for the emoji, joined with pipes
  (`|`).

#### Sample

```text
😁    Smileys & People        face-positive   beaming face with smiling eyes | eye | face | grin | smile
😂    Smileys & People        face-positive   face | face with tears of joy | joy | laugh | tear
```

### `categories.txt`

A list of all categories in the dataset. One category name per line.

#### Sample

```text
Smileys & People
Animals & Nature
Food & Drink
Travel & Places
Activities
Objects
Symbols
Flags
No category
```

### `subcategories.txt`

A list of all category-subcategory pair in the dataset. One pair per line,
separated by a tab character.

#### Sample

```text
Activities      event
Activities      award-medal
Activities      sport
Activities      game
Activities      arts & crafts
Symbols geometric
Flags   flag
Flags   country-flag
Flags   subdivision-flag
No category
```

### `all.json`

Raw data of all emojis used to generate all other data files. Basic structure is this:

```json
{
  "categories": [
    {
      "name": "Category name",
      "subcategories": [
        {
          "name": "Subcategory name",
          "emojis": [
            {
              "characters": "…",
              "keywords": {
                "lang1": ["keyword1", "keyword2"],
                "lang2": ["keyword1", "keyword2"],
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Custom views

You can implement custom views using `jq`. Add a file in `views` and name it
with either `.txt.jq` or `.json.jq` extensions depending on what you want.
`make` will pick up these files automatically and run it to build a file under
`data/`.

## Problems

### Uncategorized emojis

Some of the newer symbols lack category and subcategory. They have assigned
categories in the [CLDR][cldr] test files, but are not listed in the
`labels.txt` list that gives all emojis a category and subcategory, and can
therefore not be placed in a category.

This could be solved by also parsing the test files to get emoji candidates, or
perhaps the Unicode Consortium will update the `labels.txt` file soon.

Right now these emojis get the category "Uncategorized" and no subcategory.

### Missing combinations of emojis

Some emoji combinations (for example, people + skin color, or keypad numbers)
are not yet loaded. There are so many combinations, so it's unclear if they
should be in the dataset or left as an exercise for the user.

## Copyright

The code inside this repo is released under the GNU General Public Licence v3.0
(GPLv3). **The generated output of these scripts do not fall under this license,
and is only a product of material that is part of the [CLDR][cldr].** I do not
claim copyright to any of the data read or generated by these tools.

See `LICENSE` file for the full license text for the code in this repository. A
copy of the [Unicode license][unicode-license] is also included in
`unicode-license.txt` for dealing with the distribution of the generated data.

Code in this repo is Copyright © 2019 Magnus Bergmark.

[cldr]: http://cldr.unicode.org/
[unicode-license]: http://www.unicode.org/copyright.html
