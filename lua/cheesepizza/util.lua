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

function M.parse_contest_info(input)
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

return M
