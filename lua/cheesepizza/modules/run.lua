local M = {}

function M.run()
	local filetype = vim.bo.filetype

	local opts = M.config.langs[filetype]

	if opts == nil then
		print("No options found for filetype " .. filetype)
		return
	end

	local exe = vim.system({ "which", opts["exe"] }):wait()

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
end

function M.setup(config)
	M.config = config.run
end

return M
