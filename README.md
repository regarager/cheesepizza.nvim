# cheesepizza.nvim

A simple plugin for competitive programming in Neovim

## Heavily WIP!

## Installation

To install (for Lazy.nvim), simply add the following lines:

```lua
{
    "regarager/cheesepizza.nvim",
    event = "VeryLazy"
}
```

For `vim.pack` (Neovim v0.12+), use the following:

```lua
vim.pack.add({
    "https://github.com/regarager/cheesepizza.nvim"
})
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
- If the language is supported, the `DEBUG_MODE` variable will be toggled
  - This variable is used for disabling blocks of code that are intended only for debugging and not for final submission

### :DebugEnable
- Sets `DEBUG_MODE` to true

### :DebugDisable
- Sets `DEBUG_MODE` to false

### :Run
- The active buffer must be a supported language file (CPP, Python, Java)
- The program will be compiled (where applicable) and run
  - Input is given through a corresponding `.in` file (ex: `A.in` for `A.cpp`)

### :RunTerm
- Same as `:Run`, but all commands are executed in a Neovim terminal

### :CF
- Attempts to open the corresponding problem in the browser using `vim.ui.open`
- The filepath must either match `.../[contest]/[problem].[extension]` or `.../[contest][problem].[extension]`
  - Ex: `/home/user/programming/1337A.cpp` or `/home/user/programming/1337/A.cpp`

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
})
```

### Snippets

As of Dec. 10, 2025, snippets have been removed `cheesepizza.nvim`, since it is more practical to write your own snippet and use a snippet engine like [LuaSnip](https://github.com/L3MON4D3/LuaSnip).

The original C++ snippet can be found below:

```cpp
#include <bits/stdc++.h>
#define int long long
using namespace std;

using ld = long double;
using pi = pair<int, int>;

// clang-format off
#define has(x, y) x.find(y) != x.end()
#define all(x) x.begin(), x.end()
#define between(x, a, b) make_pair(lower_bound(x.begin(), x.end(), a), --upper_bound(x.begin(), x.end(), b))
#define YES cout << "YES" << endl;
#define NO cout << "NO" << endl;
#define DEBUG_MODE true
#define DEBUG if (DEBUG_MODE)
#define NOTDEBUG if (!DEBUG_MODE)
#define print(x) for (auto it : x) { cout << it << " "; } cout << endl
#define printm(x) for (auto it : x) { cout << it.first << ": " << it.second << endl; } cout << endl
#define printmv(x) for (auto it : x) { cout << it.first << ": "; print(it.second); }
#define printn(x, n) for (int i = 0; i < n; i++) { cout << x[i] << " \n"[i == n - 1]; }
// clang-format on

const int SIZE = 2e5 + 5;

signed main() {

}
```

Optional snippets:

```cpp
// sieve
vector<bool> sieve(SIZE, true); for (int i = 2; i < SIZE; i++) { if (!sieve[i]) continue; for (int j = i * 2; j < SIZE; j += i) sieve[j] = false; }

// primes
vector<int> primes; for (int i = 2; i < SIZE; i++) { if (sieve[i]) primes.push_back(i); }

// fastio
ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);

// tcases
int t;
cin >> t;

while (t--) {

}
```

## Coming Soon! (or not)
- [x] Quickly toggle debug mode
- [x] Diff viewer for test cases
- [ ] Contest timer
- [ ] Track solved in contest
- [ ] Web integration with CF (highly unlikely)
