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
end

function M.newcontest(opts)
	if vim.trim(opts.args) ~= "" then
		initcontest(opts.args)
	else
		vim.ui.input({
			prompt = "Enter contest name:",
		}, function(input)
			if input then
				initcontest(input)
			else
			end
		end)
	end
end

function M.setup(config)
	M.config = config.contest
end

return M
