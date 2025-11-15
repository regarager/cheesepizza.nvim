local log = require("cheesepizza.util").log

local M = {}

function M.cf_open()
	local filename = vim.api.nvim_buf_get_name(0)

	local url = "https://codeforces.com/contest/%s/problem/%s"
	local contest, problem = string.match(filename, ".*%/([0-9]+)([a-zA-Z])%.[a-zA-Z]+")
	if contest ~= nil and problem ~= nil then
		url = string.format(url, contest, problem)
		vim.ui.open(url)
		log.info("Opened " .. url)
		return
	end

	contest, problem = string.match(filename, ".*%/([0-9]+)%/([a-zA-Z]+)%.[a-zA-Z]+")
	if contest ~= nil and problem ~= nil then
		url = string.format(url, contest, problem)
		vim.ui.open(url)
		log.info("Opened " .. url)
		return
	end

	log.warn("Problem not detected for file " .. filename)
end

return M
