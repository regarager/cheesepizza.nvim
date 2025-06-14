local M = {}

M.config = require("cheesepizza.config")

local contest = require("cheesepizza.modules.contest")
local run = require("cheesepizza.modules.run")
local snippets = require("cheesepizza.modules.snippets")

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	contest.setup(M.config)
	snippets.setup(M.config)
	run.setup(M.config)
end

-- Set up a command
vim.api.nvim_create_user_command("Contest", contest.newcontest, { nargs = "*" })
vim.api.nvim_create_user_command("DebugToggle", contest.debugtoggle, { nargs = "*" })
vim.api.nvim_create_user_command("CPRun", run.run, { nargs = "*" })

return M
