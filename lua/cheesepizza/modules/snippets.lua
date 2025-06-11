local M = {}

local function setup_cpp(config)
	if not config.enabled then
		return
	end

	local ls = require("luasnip")
	local i = ls.insert_node

	if ls == nil then
		return
	end

	local s = ls.snippet
	local fmt = require("luasnip.extras.fmt").fmt

	local lines = {}

	if config.use_bits then
		table.insert(lines, "#include <bits/stdc++.h>")
	end

	if config.namespace then
		table.insert(lines, "using namespace std;")
	end

	if config.separate_sections and #lines > 0 then
		table.insert(lines, "")
	end

	if config.ll then
		table.insert(lines, "using ll = long long;")
	end

	if config.ld then
		table.insert(lines, "using ld = long double;")
	end

	if config.pi then
		table.insert(lines, "using pi = pair<int, int>;")
	end

	if config.pll then
		table.insert(lines, "using pll = pair<long long, long long>;")
	end

	if config.separate_sections and #lines > 0 then
		table.insert(lines, "")
	end

	if config.yn then
		table.insert(lines, '#define YES cout << "YES" << endl;')
		table.insert(lines, '#define NO cout << "NO" << endl;')
	end

	if config.debug then
		table.insert(lines, "#define DEBUG_MODE true")
		table.insert(lines, "#define DEBUG if (DEBUG_MODE)")
		table.insert(lines, "#define NOTDEBUG if (!DEBUG_MODE)")
	end

	if config.print_util then
		table.insert(lines, "// clang-format off")
		table.insert(lines, '#define print(x) for (auto it : x) {{ cout << it << " "; }} cout << endl;')
		table.insert(
			lines,
			'#define printm(x) for (auto it : x) {{ cout << it.first << ": " << it.second << endl; }} cout << endl;'
		)
		table.insert(lines, '#define printmv(x) for (auto it : x) {{ cout << it.first << ": "; print(it.second); }}')
		table.insert(lines, '#define printn(x, n) for (int i = 0; i < n; i++) {{ cout << x[i] << " "; }} cout << endl;')
		table.insert(lines, "// clang-format on")
	end

	if config.separate_sections and #lines > 0 then
		table.insert(lines, "")
	end

	if config.size then
		table.insert(lines, "const int SIZE = 2e5 + 5;")
	end

	if #lines > 0 then
		table.insert(lines, "")
	end

	table.insert(lines, "int main() {{")

	if config.ioopt then
		table.insert(lines, "\tios::sync_with_stdio(0);")
		table.insert(lines, "\tcin.tie(0);")
		table.insert(lines, "\tcout.tie(0);")
		table.insert(lines, "")
	end

	table.insert(lines, "\t{code}")

	table.insert(lines, "}}")

	ls.add_snippets("cpp", {
		s("cp", fmt(table.concat(lines, "\n"), { code = i(0) })),
	})
end

function M.setup(config)
	local ls = require("luasnip")
	if ls == nil then
		return
	end

	if not config.snippets.enabled then
		return
	end

	setup_cpp(config.snippets.cpp)
end

return M
