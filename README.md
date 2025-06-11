# cheesepizza.nvim
## A simple plugin for competitive programming in Neovim
### Heavily WIP!

### Installation

To install (for Lazy.nvim), simply add the following lines:

```lua
{
    "regarager/cheesepizza.nvim",
    event = "VeryLazy"
}
```

### Usage

#### :Contest
- To use the command, enter `:Contest <args>` or `:Contest`
  - If no args are provided, then a popup will appear where you can insert the arguments as you would in the first option
- Argument format `<CONTEST> <SIZE> [LANG]`
  - `CONTEST` - the name/number/id of the contest (ex: 1234)
  - `SIZE` - the number of questions in the contest
  - `LANG` (optional) - the extension to use, defaults to the `lang` option in configuration.

### Configuration

The default options are below (as well as in `lua/cheesepizza/config.lua`):

```lua
require("cheesepizza").setup({
	-- Generation of files for contests
	contest = {
		lang = "cpp", -- Default file extension/language to use
		lettered_files = true, -- use letters as file names (A.cpp, B.cpp, ...) instead of numbers (1.cpp, 2.cpp, ...)
	},
	-- Templates to use for contests, USE AT YOUR OWN RISK
	snippets = {
		enabled = true, -- enables/disables the section
		cpp = {
			enabled = true, -- enables/disables the section

			use_bits = true, -- use `#include <bits/stdc++.h>`
			namespace = true, -- use `using namespace std;`

			ll = true, -- use ll = long long
			ld = true, -- use ld = long double
			pi = true, -- use pi = pair<int, int>
			pll = true, -- use pll = pair<long long, long long>

			yn = true, -- use YES and NO to print either yes/no (for CF)
			debug = true, -- debugging macros
			print_util = true, -- macros for printing arrays, vectors, maps

			size = true, -- set a constant size variable (default: 2e5 + 5)

			ioopt = true, -- improve io speed
			separate_sections = true, -- add spacing between different sections of the snippet, sections follow the splitting in this file
		},
	},
})
```

### Coming Soon! (or not)
- [ ] Quickly toggle debug mode
- [ ] More snippets
- [ ] Contest timer
- [ ] Track solved in contest
- [ ] Web integration with CF (highly unlikely)
