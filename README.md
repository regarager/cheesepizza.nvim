# cheesepizza.nvim

<center>A simple plugin for competitive programming in Neovim</center>

## Heavily WIP!

## Installation

To install (for Lazy.nvim), simply add the following lines:

```lua
{
    "regarager/cheesepizza.nvim",
    event = "VeryLazy"
}
```

## Usage

### :Contest
- To use the command, enter `:Contest <args>` or `:Contest`
  - If no args are provided, then a popup will appear where you can insert the arguments as you would in the first option
- Argument format `<CONTEST> <SIZE> [LANG]`
  - `CONTEST` - the name/number/id of the contest (ex: 1234)
  - `SIZE` - the number of questions in the contest
  - `LANG` (optional) - the extension to use, defaults to the `lang` option in configuration.

### :DebugToggle
- To use the command, enter `:DebugToggle`
- If the language is supported, the `DEBUG_MODE` variable will be toggled
  - This variable is used for disabling blocks of code that are intended only for debugging and not for final submission

### :DebugEnable
- To use the command, enter `:DebugEnable`
- Sets `DEBUG_MODE` to true

### :DebugDisable
- To use the command, enter `:DebugDisable`
- Sets `DEBUG_MODE` to false

### :Run
- To use the command, enter `:Run`
  - The active buffer must be a supported language file (CPP, Python, Java)
- The program will be compiled (where applicable) and run
  - Input is given through a corresponding `.in` file (ex: `A.in` for `A.cpp`)

### :RunTerm
- To use the command, enter `:RunTerm`
- Same as `:Run`, but all commands are executed in a Neovim terminal

## Configuration

### Setup

```lua
require("cheesepizza").setup({}) -- default options below

-- creates keybind, recommended for speed
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "java", "cpp" },
    callback = function()
        vim.keymap.set("n", "<leader>r", ":RunTerm<CR>")
    end,
})
```

### Default Options
The default options are below (as well as in `lua/cheesepizza/config.lua`):

```lua
require("cheesepizza").setup({
	-- Running files
	run = {
		-- output diff viewer
		output = "split", -- "popup", "split", or "none"
		diff = {
			automatic = true, -- automatically open diff view
			warn_missing_ans = false, -- warn if answer file is missing
		},
		-- compilation commands
		langs = {
			cpp = {
				compile = true,
				clean = true,
				exe = "g++",
				args = { "-Wall", "-Wextra", "-pedantic", "-std=c++23", "-O2", "-Wshadow", "-g", "-D_GLIBCXX_DEBUG" },
				run = "./a.out",
			},
			java = {
				compile = true,
				clean = true,
				exe = "java",
				args = {},
			},
			python = {
				clean = false,
				exe = "python",
				args = {},
			},
		},
	},
	-- Debug configuration
	debug = {
		autowrite = true,
	},
	-- Generation of files for contests
	contest = {
		lang = "cpp", -- default file extension/language to use
		-- function to generate file names (excluding extension), defaults to A, B, C, ...
		filename = function(i)
			return require("cheesepizza.util").letters[i]
		end,
		change_dir = true, -- automatically :cd into the new contest directory
		input_files = false, -- automatically create .in files
	},
	-- Templates to use for contests, USE AT YOUR OWN RISK
	snippets = {
		enabled = true, -- enables/disables the section
		cpp = {
			enabled = true, -- enables/disables the section
			-- Generation of problem template
			template = {
				enabled = true, -- enables/disables the section
				use_bits = true, -- use `#include <bits/stdc++.h>`
				namespace = true, -- use `using namespace std;`

				ll = true, -- use ll = long long
				ld = true, -- use ld = long double
				pi = true, -- use pi = pair<int, int>
				pll = true, -- use pll = pair<long long, long long>

				it_has = true, -- short hand for x.find(y) != x.end()
				it_all = true, -- short hand for x.begin(), x.end()

				yn = true, -- use YES and NO to print either yes/no (for CF)
				debug = true, -- debugging macros
				print_util = true, -- macros for printing arrays, vectors, maps

				size = true, -- set a constant size variable (default: 2e5 + 5)

				separate_sections = true, -- add spacing between different sections of the snippet, sections follow the splitting in this file
			},
			-- Snippets that are not included in template but can be used when needed
			optional = {
				enabled = true,
				fastio = true, -- improve io speed
				sieve = true, -- generates sieve of eratosthenes
				primes = true, -- generates list of primes (both recommended)
			},
		},
	},
})
```

## Coming Soon! (or not)
- [x] Quickly toggle debug mode
- [x] Diff viewer for test cases
- [ ] More snippets
- [ ] Contest timer
- [ ] Track solved in contest
- [ ] Web integration with CF (highly unlikely)
