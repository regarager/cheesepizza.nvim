local util = require("cheesepizza.util")
local M = {}

function M.showdiff()
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
	local out_file = base .. ".out"
	local ans_file = base .. ".ans"

	-- Validate files exist
	if not util.fileexists(out_file) then
		print("Missing file " .. out_file .. ", try :CPRun")
		return
	end
	if not util.fileexists(ans_file) then
		print("Missing file " .. ans_file .. ", try creating it")
		return
	end

	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.8)
	local height = math.floor(ui.height * 0.8)
	local col = (ui.width - width) / 2
	local row = (ui.height - height) / 2

	local left_buf = vim.fn.bufadd(out_file)
	local right_buf = vim.fn.bufadd(ans_file)
	vim.fn.bufload(left_buf)
	vim.fn.bufload(right_buf)

	local win_config = {
		relative = "editor",
		width = math.floor(width / 2),
		height = height,
		row = row,
		style = "minimal",
		border = "single",
	}

	-- Create windows
	local left_win = vim.api.nvim_open_win(
		left_buf,
		true,
		vim.tbl_extend("keep", win_config, {
			col = col,
		})
	)

	local right_win = vim.api.nvim_open_win(
		right_buf,
		true,
		vim.tbl_extend("keep", win_config, {
			col = col + win_config.width,
		})
	)

	for _, win in ipairs({ left_win, right_win }) do
		vim.api.nvim_win_set_option(win, "number", true)
		vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal,NormalNC:Normal")
		vim.cmd("diffthis")
	end

	for _, buf in ipairs({ left_buf, right_buf }) do
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("set number")
			vim.cmd("diffthis")
		end)
	end

	local function close_windows()
		if vim.api.nvim_win_is_valid(left_win) then
			vim.api.nvim_win_close(left_win, true)
		end
		if vim.api.nvim_win_is_valid(right_win) then
			vim.api.nvim_win_close(right_win, true)
		end
	end

	vim.keymap.set("n", "q", close_windows, { buffer = left_buf })
	vim.keymap.set("n", "q", close_windows, { buffer = right_buf })

	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			local current_win = vim.api.nvim_get_current_win()
			if current_win ~= left_win and current_win ~= right_win then
				close_windows()
			end
		end,
		nested = true,
	})
end

function M.run()
	local filetype = vim.bo.filetype

	local opts = M.config.langs[filetype]

	if opts == nil then
		print("No options found for filetype " .. filetype)
		return
	end

	local exe = util.which(opts["exe"])

	if exe == "" then
		print(opts["exe"] .. " was not found")
		return
	end

	local args = opts["args"]
	table.insert(args, 1, exe)
	table.insert(args, vim.api.nvim_buf_get_name(0))

	if opts["compile"] then
		local output = vim.system(args, {
			text = true,
			cwd = vim.fn.getcwd(),
		}):wait()
		if output.code ~= 0 then
			print("Compilation error: " .. output.stderr)
		else
			print("Finished compiling!")
		end
	end

	local cmd = string.format(opts.run, vim.api.nvim_buf_get_name(0))
	local input_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r") .. ".in"

	cmd = cmd .. " < " .. input_file

	if vim.fn.filereadable(input_file) then
		local s = string.format("cd %s && %s", vim.fn.getcwd(), cmd)
		local output = vim.fn.system(s)
		print(output)
	else
		print("Input file not found")
	end

	if M.config.diff.automatic then
		M.showdiff()
	end
end

function M.setup(config)
	M.config = config.run
end

return M
