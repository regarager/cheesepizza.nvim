local util = require("cheesepizza.util")
local M = {}

local function show_split(left_buf, right_buf)
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.8)
	local height = math.floor(ui.height * 0.8)
	local col = (ui.width - width) / 2
	local row = (ui.height - height) / 2

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

	local gap = 4

	-- Create windows
	local left_win = vim.api.nvim_open_win(
		left_buf,
		true,
		vim.tbl_extend("keep", win_config, {
			col = col - gap / 2,
		})
	)

	local right_win = vim.api.nvim_open_win(
		right_buf,
		true,
		vim.tbl_extend("keep", win_config, {
			col = col + win_config.width + gap / 2,
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

local function show_single(left_buf)
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.8)
	local height = math.floor(ui.height * 0.8)
	local row = (ui.height - height) / 2
	local col = (ui.width - width / 2) / 2

	vim.fn.bufload(left_buf)

	local win_config = {
		relative = "editor",
		width = math.floor(width / 2),
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "single",
	}

	-- Create windows
	local left_win = vim.api.nvim_open_win(left_buf, true, win_config)

	vim.api.nvim_win_set_option(left_win, "number", true)
	vim.api.nvim_win_set_option(left_win, "winhl", "Normal:Normal,NormalNC:Normal")
	vim.api.nvim_buf_call(left_buf, function()
		vim.cmd("set number")
	end)

	local function close_windows()
		if vim.api.nvim_win_is_valid(left_win) then
			vim.api.nvim_win_close(left_win, true)
		end
	end

	vim.keymap.set("n", "q", close_windows, { buffer = left_buf })

	vim.api.nvim_create_autocmd("WinEnter", {
		callback = function()
			local current_win = vim.api.nvim_get_current_win()
			if current_win ~= left_win then
				close_windows()
			end
		end,
		nested = true,
	})
end

function M.showdiff(output)
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
	local ans_file = base .. ".ans"

	local show_ans = true
	-- Validate files exist
	if not util.fileexists(ans_file) then
		vim.notify("Missing file " .. ans_file .. ", try creating it", vim.log.levels.WARN, { title = "Warning" })
		show_ans = false
	end

	local left_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(left_buf, 0, -1, false, vim.split(output, "\n", { plain = true }))

	local ns1 = vim.api.nvim_create_namespace("output_win")
	vim.api.nvim_buf_set_extmark(left_buf, ns1, 0, 0, {
		virt_text = { { "Output", "Title" } },
		virt_text_pos = "right_align", -- Or "inline", "overlay"
	})

	if show_ans then
		local right_buf = vim.fn.bufadd(ans_file)

		local ns2 = vim.api.nvim_create_namespace("answer_win")
		vim.api.nvim_buf_set_extmark(right_buf, ns2, 0, 0, {
			virt_text = { { "Answer", "Title" } },
			virt_text_pos = "right_align", -- Or "inline", "overlay"
		})

		show_split(left_buf, right_buf)
	else
		show_single(left_buf)
	end
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

	exe = exe:gsub("%s+", "")

	local args = { (table.unpack or unpack)(opts["args"]) }
	table.insert(args, 1, exe)
	table.insert(args, vim.api.nvim_buf_get_name(0))

	if opts["compile"] then
		local output = vim.system(args, {
			text = true,
			cwd = vim.fn.getcwd(),
		}):wait()
		if output.code ~= 0 then
			vim.notify("Compilation error: " .. output.stderr, vim.log.levels.ERROR)
			vim.notify("Compile command: " .. table.concat(args, " "))
			return
		else
			print("Finished compiling!")
		end
	end

	local cmd = string.format(opts.run, vim.api.nvim_buf_get_name(0))
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
	local input_file = base .. ".in"

	cmd = cmd .. " < " .. input_file

	local output = ""
	if vim.fn.filereadable(input_file) then
		local s = string.format("cd %s && %s", vim.fn.getcwd(), cmd)
		output = vim.fn.system(s)
		if opts["clean"] then
			local clean_cmd = string.format("cd %s && rm %s", vim.fn.getcwd(), opts["run"])
			local clean_output = vim.fn.system(clean_cmd)

			if #clean_output > 0 then
				print("Error while cleaning file: " .. output)
			end
		end
	else
		print("Input file not found")
	end

	if M.config.diff.automatic then
		M.showdiff(output)
	end
end

function M.setup(config)
	M.config = config.run
end

return M
