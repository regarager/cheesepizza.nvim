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

local function has_ansfile(ans_file)
	if not util.fileexists(ans_file) then
		if M.config.diff.warn_missing_ans then
			util.log.warn("Missing file " .. ans_file .. ", try creating it")
		end
		return false
	end
	return true
end

local function showdiff_popup(base, output, ans_file)
	local show_ans = has_ansfile(ans_file)

	local left_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(left_buf, 0, -1, false, vim.split(output, "\n", { plain = true }))

	local ns1 = vim.api.nvim_create_namespace("output_win")
	vim.api.nvim_buf_set_extmark(left_buf, ns1, 0, 0, {
		virt_text = { { base .. " - Output", "Title" } },
		virt_text_pos = "right_align",
	})

	if show_ans then
		local right_buf = vim.fn.bufadd(ans_file)

		local ns2 = vim.api.nvim_create_namespace("answer_win")
		vim.api.nvim_buf_set_extmark(right_buf, ns2, 0, 0, {
			virt_text = { { "Answer", "Title" } },
			virt_text_pos = "right_align",
		})

		show_split(left_buf, right_buf)
	else
		show_single(left_buf)
	end
end

local function showdiff_split(base, output, ans_file)
	local show_ans = has_ansfile(ans_file)

	local out_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(out_buf, base .. " - Output " .. os.time())
	vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, vim.split(output, "\n", { plain = true }))

	vim.cmd("vsplit")
	vim.cmd("diffthis")

	vim.api.nvim_set_current_buf(out_buf)

	if show_ans then
		vim.cmd("split")
		vim.cmd("e " .. ans_file)
		vim.cmd("diffthis")
	end
end

local function showdiff(output)
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")
	local ans_file = base .. ".ans"

	if M.config.output == "popup" then
		showdiff_popup(base, output, ans_file)
	elseif M.config.output == "split" then
		showdiff_split(base, output, ans_file)
	elseif M.config.output == "none" then
	-- do nothing
	else
		util.log.error("Output method " .. M.config.output .. " is not a valid option")
	end
end

function M.run()
	local filetype = vim.bo.filetype

	local opts = M.config.langs[filetype]

	if opts == nil then
		util.log.error("No options found for filetype " .. filetype)
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
			util.log.error("Compilation error: " .. output.stderr)
			util.log.debug("Compile command: " .. table.concat(args, " "))
			return
		else
			util.log.info("Finished compiling!")
		end
	end

	local cmd = string.format(opts.run, vim.api.nvim_buf_get_name(0))
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")

	local input_file = base .. ".in"

	if not util.fileexists(input_file) then
		util.log.error("File " .. input_file .. " does not exist")
		return
	end
	cmd = cmd .. " < " .. input_file

	local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
	local input = vim.fn.readfile(input_file)

	args = vim.split(cmd, " ", { plain = true })
	vim.system(args, {
		cwd = dir,
		text = true,
		stdin = table.concat(input, "\n"),
	}, function(result)
		local output = (result.stdout or "") .. (result.stderr or "")
		if #output > 0 then
			output = output .. "\n"
		end

		output = output .. string.format("[exited with code %d]", result.code)

		if M.config.diff.automatic then
			vim.schedule(function()
				showdiff(output)
			end)
		end
	end)

	if opts["clean"] then
		local clean_cmd = string.format("cd %s && rm %s", vim.fn.getcwd(), opts["run"])
		local clean_output = vim.fn.system(clean_cmd)

		if #clean_output > 0 then
			util.log.error("Error while cleaning file: " .. clean_output)
		end
	end
end

function M.run_term()
	local filetype = vim.bo.filetype

	local opts = M.config.langs[filetype]

	if opts == nil then
		util.log.error("No options found for filetype " .. filetype)
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

	local run_cmd = string.format(opts.run, vim.api.nvim_buf_get_name(0))
	local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t:r")

	local input_file = base .. ".in"

	vim.cmd("vsplit")
	vim.cmd("terminal")
	local buf = vim.api.nvim_get_current_buf()
	local term_chan = vim.api.nvim_buf_get_var(buf, "terminal_job_id")

	if opts["compile"] then
		local compile_cmd = table.concat(args, " ")
		vim.api.nvim_chan_send(term_chan, compile_cmd .. "\n")
	end

	local input_exists = util.fileexists(input_file)
	if not input_exists then
		util.log.error("File " .. input_file .. " does not exist")
	else
		run_cmd = run_cmd .. " < " .. input_file
	end

	vim.api.nvim_chan_send(term_chan, run_cmd .. "\n")

	if input_exists and opts["clean"] then
		local clean_cmd = string.format("cd %s && rm %s", vim.fn.getcwd(), opts["run"])
		vim.api.nvim_chan_send(term_chan, clean_cmd)
		vim.api.nvim_chan_send(term_chan, "\n") -- not needed, just for visual
	end
end

function M.setup(config)
	M.config = config.run
end

return M
