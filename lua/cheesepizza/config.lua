local M = {
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
}

return M
