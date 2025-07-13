local M = {
	-- Running files
	run = {
		-- output diff viewer
		diff = {
			automatic = true, -- automatically open diff view
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
}

return M
