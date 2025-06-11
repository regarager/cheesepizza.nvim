local M = {}

M.config = require("cheesepizza.config")

local snippets = require("cheesepizza.modules.snippets")
local contest = require("cheesepizza.modules.contest")

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	snippets.setup(M.config)
	contest.setup(M.config)
end

-- Set up a command
vim.api.nvim_create_user_command("Contest", contest.newcontest, { nargs = "*" })

return M
