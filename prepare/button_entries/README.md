# Writing your button entries
## Directory structure
- Button entries are split by target language and are named `button_entries_<language_code>.yaml`

## Document structure
### `<language_code>` node
Each document has top node called by the file language code
#### `common` node
`common` node contains the following entries:
- `repair` - the original string of forgotten "REPAIR" button
- `wait` - some string about encouraing user to stop before beggining a battle
- `exit` - some string encouraing user to exit game
- `quack` - duckies! "Quack~" string translation goes here
- Entries which can be resent regardles of current button type
#### `<button_type>` node
`<button_type>` node contains entries specific to the button.
`<button_type>` is one of:
- `BattleWrapper`
- `TrainingButton`
- `ReadyButton`
- `NotReadyButton`
- `BackToSquadButton`

##### Entry transformations
Entry transformations are written in `.<lang_code>.<button_type>` node applied to the `.<lang_code>.<button_type>.original` entry.
Here are some transformations and how to programatically get them:
| Node name                  | Description                                                                 | How to get                                           |
|----------------------------|-----------------------------------------------------------------------------|------------------------------------------------------|
| `original`                 | Original button label that you see in game                                  | The localization file                                |
| `tr_tonumber`              | Map `letter -> number in the alphabet`. E.g. for `en`: `y -> 25, SPC -> 0`. | Manually                                             |
| `tr_rot13`                 | Apply [rot13][ROT13] letter substitution.                                   | `rot` from `fortune`                                 |
| `tr_reverse`               | Reverse the string by characters.                                           | `rev` from `coreutils`                               |
| `tr_atbash`                | Apply [ATBASH][ATBASH] letter substitution.                                 | `atbash.sh` shipped with this repository             |
| `tr_morse`                 | Convert string to Morse code.                                               | [Online translator][Morse_online]                    |
| `tr_cyrillic_punto`        | English except it's typed while using some Cyrillic QWERTY keyboard layout. | BATTLE! -> [type in ru] ИФЕЕДУ!                      |
| `tr_cyrillic_punto_invert` | Some Cyrillic except it's typed on English QWERTY keyboard layout.          | В БОЙ! -> [type in en] D <JQ!                        |
| `tr_cyrillic_bnopnya`      | Text from CP1251 encoding displayed in KOI8-R encoding. [Link][Bnopnya]     | `echo <input> \| iconv -t cp1251 \| iconv -f koi8-r` |
| `tr_cyrillic_koi7`         | Latin text displayed in cyrillic KOI7 encoding. [Link][KOI7]                | `koi7.sh` shipped with this repository               |

[ROT13]: https://en.wikipedia.org/wiki/ROT13
[ATBASH]: https://en.wikipedia.org/wiki/Atbash
[Morse_online]: https://morsecode.world/international/translator.html
[Bnopnya]: https://neolurk.org/wiki/%D0%91%D0%9D%D0%9E%D0%9F%D0%9D%D0%AF
[KOI7]: https://neolurk.org/wiki/%D0%98%D0%BD%D0%B6%D0%B0%D0%BB%D0%B8%D0%B4_%D0%B4%D0%B5%D0%B6%D0%B8%D1%86%D0%B5

#### `dynamic_vars` node
Insert custom variables for dynamic entries here, written exactly like in WG yaml files. The entries are appended to the `UIDataLocalVarsComponent.data`.

## Rules
1. Escape the following symbols:
   - `\u201D` for `"`
   - `\u2019` for `'`
   - `\u005C` for `\`
   - `\u0023` for `#`
   - for `$` write `USD` instead, (it's hard to escape dollar sign correctly in makefile)
2. Separate letter codes with literal `\b` for `tr_tonumber` entry for better readability. Example:
```yaml
tr_tonumber: ["1\b2\b3"]
```
3. List entries in array form only, even if they contatin only one entry. It makes much easier to parse and aggregate entries.
4. Entries where there can be only one variant (direct transformations e.g. `tr_tonumber`, `tr_reverse`, etc) must be written in "flow" style. Incorrect example:
```yaml
tr_tonumber:
- "1\b2\b3"
```
Correct example: see rule 2

5. Rules about writing your entry with dynamic variables:
   - The value of entry which use dynamic variables must begin and end with `@@`
   - Use `str()` to convert int to string
   - Use `+` operator to concatenate between tokens
   - Escape double quotes (`\"`) in these entries as they will be unquoted by the script in order for variables to be readable

Example:
```yaml
- "@@str(variable_1) + \" quoted part \" + str(variable_2) + some_string_variable@@"
```
6. The "n/a" is written when the entry cannot be specified. For example, `.en.common.original` entry is meaninglesss but necessary for parser to not output "null"
7. All dynamic variables must be defined in `.<target_language>.dynamic_vars` section. They must be written in the form suitable for the DAVA UI YAML files.
Example:
```yaml
lang:
    # ...
    dynamic_vars:
    - ["<type>", "<name>", "<value>"]
    # ...
```

# Which button entries are included in string pool
- `.<language_code>.<button_type>.*` - for specific language and for specific button type
- `.*.<button_type>.original` - all original entry translations
- `.<language_code>.*.original` - all original entries in specific language
- `.any.<button_type>.*` - language-independent entries suitable only for specific button type
- `.any.common.*` - language-independent entries suitable anywhere
- `.<language_code>.common.*` - entries suitable anywhere for specific language
