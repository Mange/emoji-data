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
2. `bundler` (Ruby gem manager) installed.
3. `jq` command-line JSON processor.

You can check your dependencies by running `make setup`. It will also install
the Ruby gems that are missing.

### Generating the data

Run `make` (or `make all`) to build all data files. You can rerun this as often
as you want; only outdated files will be rebuilt.

### List of views

Here are the current views, and an example of how they look like.

#### `all_emojis.json`

An JSON array of all emojis as objects with the following keys:

* `characters` - **String**. The Unicode characters that make up the emoji.
* `name` - **String**. The name of the emoji, or `en_tts_description` if no
  name was found.
* `category_name` - **String**. The name of the category the emoji resides in.
* `subcategory_name` - **String | `null`**. The name of the subcategory the
  emoji resides in.
* `en_keywords` - **Array<String>**. List of English keywords for the emoji.
* `en_tts_description` - **String**. The English TTS description of the emoji.
* `qualification` - **String**. Either "fully-qualified", "unqualified", or
  undetermined.

##### Sample

```json
[
  {
    "characters": "😂",
    "name": "face with tears of joy",
    "category_name": "Smileys & People",
    "subcategory_name": "face-positive",
    "en_keywords": [
      "face",
      "joy",
      "laugh",
      "tear"
    ],
    "en_tts_description": "face with tears of joy",
    "qualification": "fully-qualified"
  },
  {
    "characters": "😃",
    "name": "grinning face with big eyes",
    "category_name": "Smileys & People",
    "subcategory_name": "face-positive",
    "en_keywords": [
      "face",
      "mouth",
      "open",
      "smile"
    ],
    "en_tts_description": "grinning face with big eyes",
    "qualification": "fully-qualified"
  }
]
```

#### `all_emojis.txt`

A tab-separated text file with one emoji on each line. Keywords are joined with
pipes (`|`) in the last column.

Columns are, in order:

* `characters` - The Unicode characters that make up the emoji.
* `category_name` - The name of the category the emoji resides in.
* `subcategory_name` - The name of the subcategory the emoji resides in. Can be
  empty.
* `name` - The name of the emoji, or TTS description if no name was found.
* `en_keywords` - List of English keywords for the emoji, joined with pipes
  (`|`).

##### Sample

```text
😁    Smileys & People        face-positive   beaming face with smiling eyes	beaming face with smiling eyes | eye | face | grin | smile
😂    Smileys & People        face-positive   face with tears of joy	face | face with tears of joy | joy | laugh | tear
```

#### `categories.txt`

A list of all categories in the dataset. One category name per line.

##### Sample

```text
Smileys & People
Animals & Nature
Food & Drink
Travel & Places
Activities
Objects
Symbols
Flags
Smileys & Emotion
People & Body
```

#### `subcategories.txt`

A list of all category-subcategory pair in the dataset. One pair per line,
separated by a tab character.

##### Sample

```text
Symbols keycap
Symbols alphanum
Symbols geometric
Symbols gender
Flags   flag
Flags   country-flag
Flags   subdivision-flag
Smileys & Emotion       face-affection
Smileys & Emotion       face-hat
Smileys & Emotion       face-concerned
Smileys & Emotion       face-negative
Smileys & Emotion       emotion
People & Body   hand-fingers-open
People & Body   hand-fingers-partial
People & Body   hand-single-finger
People & Body   hand-fingers-closed
```

#### `subcategories_count.txt`

Like `subcategories.txt`, but every line has an additional column with the
total amount of emojis residing under that category/subcategory pair.

##### Sample

```text
People & Body person-role 488
People & Body person-fantasy  208
People & Body person-activity 294
People & Body person-sport  346
People & Body person-resting  37
People & Body family  77
People & Body person-symbol 2
```

#### `versions_count.txt`

Counts the number of recorded Emojis from each version of the Unicode standard.

You can read up on [what the versions mean][emoji-versions] in the [Unicode
Technical Standard #51][tr51].

##### Sample

```text
E0.6  793
E0.7  254
E1.0  512
E2.0  297
E3.0  157
E4.0  1030
E5.0  339
E11.0 188
E12.0 266
E12.1 186
E13.0 146
E13.1 422
```

#### `all.json`

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
              "name": "name of the emoji",
              "version": "E1.0",
              "keywords": {
                "lang1": ["keyword1", "keyword2"],
                "lang2": ["keyword1", "keyword2"]
              },
              "tts_descriptions": {"lang1": "TTS description"},
              "qualification": "fully-qualified"
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
[tr51]: http://www.unicode.org/reports/tr51/
[emoji-versions]: http://www.unicode.org/reports/tr51/#EmojiVersions
