local M = {
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
}

return M
