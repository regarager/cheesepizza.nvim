local M = {}

M.letters = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}

function M.fileexists(file)
	return vim.fn.filereadable(file) == 1
end

function M.ends_width(s, suffix)
	return s:sub(-#suffix) == suffix
end

function M.which(exe)
	local path = vim.system({ "which", exe }):wait()
	return path.stdout
end

M.log = {}

function M.log.warn(msg)
	vim.notify(msg, vim.log.levels.WARN)
end

function M.log.error(msg)
	vim.notify(msg, vim.log.levels.ERROR)
end

function M.log.info(msg)
	vim.notify(msg, vim.log.levels.INFO)
end

function M.log.debug(msg)
	vim.notify(msg, vim.log.levels.DEBUG)
end

return M
