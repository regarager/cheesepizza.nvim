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

return M
