local M = {}

local function parse_contest_info(input)
	local parts = {}
	for part in string.gmatch(input, "%S+") do
		table.insert(parts, part)
	end

	local first = parts[1] or ""
	local second = 0
	local third = parts[3]

	if parts[2] then
		if string.match(parts[2], "^%-?%d+$") then
			second = tonumber(parts[2])
		end
	end

	return first, second, third
end

local function initcontest(input)
	local contest, problems, ext = parse_contest_info(input)
	vim.fn.mkdir(contest, "p")

	for i = 1, problems, 1 do
		local name = M.config.filename(i)

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
