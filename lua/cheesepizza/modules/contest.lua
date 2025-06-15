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

		local filename = contest .. "/" .. name
		local f = io.open(filename .. "." .. (ext or M.config.lang), "w")
		local fin = io.open(filename .. ".in", "w")

		if f then
			f:write("")
			f:close()
		end

		if fin then
			fin:write("")
			fin:close()
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

	print('Created contest "' .. contest .. '"!')
end

function M.setup(config)
	M.config = config.contest
end

return M
