local util = require("cheesepizza.util")

local M = {}

local function initcontest(input)
	local contest, problems, ext = util.parse_contest_info(input)
	vim.fn.mkdir(contest, "p")

	for i = 1, problems, 1 do
		local name = tostring(i)
		if M.config.lettered_files then
			name = util.letters[i]
		end

		local f = io.open(contest .. "/" .. name .. "." .. (ext or M.config.lang), "w")

		if f then
			f:write("")
			f:close()
		end
	end

	return contest
end

function M.newcontest(opts)
	local contest = ""
	if vim.trim(opts.args) ~= "" then
		contest = initcontest(opts.args)
	else
		vim.ui.input({
			prompt = "Enter contest name:",
		}, function(input)
			if input then
				contest = initcontest(input)
			else
			end
		end)
	end

	if M.config.change_dir then
		vim.cmd(":cd " .. contest, { silent = true })
	end

	print("Created contest " .. contest .. "!")
end

-- patterns to look for when searching for debug line
local debug_lines = {
	cpp = "#define DEBUG_MODE",
}

local function debug_regex(pattern)
	return "^" .. pattern .. "%s+(%a+)"
end

local function get_debug_line(regex)
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for i, line in ipairs(lines) do
		if line:match(regex) then
			return i, line
		end
	end

	return -1, ""
end

local function toggle_boolean(filetype, value)
	if filetype == "java" or filetype == "cpp" then
		if value == "false" then
			return "true"
		else
			return "false"
		end
	elseif filetype == "py" then
		if value == "False" then
			return "True"
		else
			return "False"
		end
	end
end

function M.debugtoggle()
	local filetype = vim.bo.filetype

	if debug_lines[filetype] == nil then
		return -1, ""
	end

	local match = debug_regex(debug_lines[filetype])

	local line_number, line = get_debug_line(match)

	local value = line:match(match)

	local newvalue = toggle_boolean(filetype, value)

	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { debug_lines[filetype] .. " " .. newvalue })

	print(filetype)
	print("Set DEBUG_MODE to " .. newvalue)
end

function M.debugenable() end

function M.debugdisable() end

function M.setup(config)
	M.config = config.contest
end

return M
