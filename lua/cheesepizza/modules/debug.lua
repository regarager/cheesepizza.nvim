local M = {}

-- patterns to look for when searching for debug line
-- TODO: add patterns for java, python
local debug_lines = {
	cpp = "#define DEBUG_MODE",
}

local function write()
	if M.config.autowrite then
		vim.cmd("w", { silent = true })
	end
end

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

local function parse_boolean(filetype, value)
	if filetype == "java" or filetype == "cpp" then
		if value == "false" then
			return false
		else
			return true
		end
	elseif filetype == "py" then
		if value == "False" then
			return false
		else
			return true
		end
	end
end

local function boolean_string(filetype, value)
	if filetype == "java" or filetype == "cpp" then
		if value then
			return "true"
		else
			return "false"
		end
	elseif filetype == "py" then
		if value then
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

	local newvalue = boolean_string(filetype, not parse_boolean(filetype, value))

	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { debug_lines[filetype] .. " " .. newvalue })

	print("Set DEBUG_MODE to " .. newvalue)
	write()
end

function M.debugenable()
	local filetype = vim.bo.filetype

	if debug_lines[filetype] == nil then
		return -1, ""
	end

	local match = debug_regex(debug_lines[filetype])

	local line_number, _ = get_debug_line(match)

	local newvalue = boolean_string(filetype, true)

	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { debug_lines[filetype] .. " " .. newvalue })

	print("Set DEBUG_MODE to " .. newvalue)
	write()
end

function M.debugdisable()
	local filetype = vim.bo.filetype

	if debug_lines[filetype] == nil then
		return -1, ""
	end

	local match = debug_regex(debug_lines[filetype])

	local line_number, _ = get_debug_line(match)

	local newvalue = boolean_string(filetype, false)

	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { debug_lines[filetype] .. " " .. newvalue })

	print("Set DEBUG_MODE to " .. newvalue)
	write()
end

function M.setup(config)
	M.config = config.debug
end

return M
