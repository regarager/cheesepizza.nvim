local ls = require("luasnip")
local i = ls.insert_node

local s = ls.snippet
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local M = {}

local function setup_cpp_template(config)
	if not config.enabled then
		return
	end

	local lines = {}

	if config.use_bits then
		table.insert(lines, "#include <bits/stdc++.h>")
	end

	if config.int_long_long then
		table.insert(lines, "#define int long long")
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

	table.insert(lines, "// clang-format off")

	if config.it_has then
		table.insert(lines, "#define has(x, y) x.find(y) != x.end()")
	end

	if config.it_all then
		table.insert(lines, "#define all(x) x.begin(), x.end()")
	end

	if config.it_between then
		table.insert(
			lines,
			"#define between(x, a, b) make_pair(lower_bound(x.begin(), x.end(), a), --upper_bound(x.begin(), x.end(), b))"
		)
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
		table.insert(lines, '#define print(x) for (auto it : x) {{ cout << it << " "; }} cout << endl;')
		table.insert(
			lines,
			'#define printm(x) for (auto it : x) {{ cout << it.first << ": " << it.second << endl; }} cout << endl;'
		)
		table.insert(lines, '#define printmv(x) for (auto it : x) {{ cout << it.first << ": "; print(it.second); }}')
		table.insert(lines, '#define printn(x, n) for (int i = 0; i < n; i++) {{ cout << x[i] << " "; }} cout << endl;')
	end

	table.insert(lines, "// clang-format on")

	if config.separate_sections and #lines > 0 then
		table.insert(lines, "")
	end

	if config.size then
		table.insert(lines, "const int SIZE = 2e5 + 5;")
	end

	if #lines > 0 then
		table.insert(lines, "")
	end

	if config.int_long_long then
		table.insert(lines, "signed main() {{")
	else
		table.insert(lines, "int main() {{")
	end

	table.insert(lines, "\t{code}")

	table.insert(lines, "}}")

	ls.add_snippets("cpp", {
		s("cp", fmt(table.concat(lines, "\n"), { code = i(1) })),
	})
end

local function setup_cpp_optional(config)
	if not config.enabled then
		return
	end

	if config.sieve then
		ls.add_snippets("cpp", {
			s(
				"sieve",
				t(
					"vector<bool> sieve(SIZE, true); for (int i = 2; i < SIZE; i++) { if (!sieve[i]) continue; for (int j = i * 2; j < SIZE; j += i) sieve[j] = false; }"
				)
			),
		})
	end

	if config.primes then
		ls.add_snippets("cpp", {
			s("primes", t("vector<int> primes; for (int i = 2; i < SIZE; i++) { if (sieve[i]) primes.push_back(i); }")),
		})
	end

	if config.fastio then
		local lines = {}
		table.insert(lines, "ios::sync_with_stdio(0);")
		table.insert(lines, "cin.tie(0);")
		table.insert(lines, "cout.tie(0);")
		ls.add_snippets("cpp", {
			s("fastio", t(lines)),
		})
	end

	if config.test_cases then
		local lines = {}
		table.insert(lines, "int t;")
		table.insert(lines, "cin >> t;")
		table.insert(lines, "")
		table.insert(lines, "while (t--) {{")
		table.insert(lines, "\t{code}")
		table.insert(lines, "}}")

		ls.add_snippets("cpp", { s("tcases", fmt(table.concat(lines, "\n"), { code = i(1) })) })
	end
end

local function setup_cpp(config)
	if not config.enabled then
		return
	end

	setup_cpp_template(config.template)
	setup_cpp_optional(config.optional)
end

function M.setup(config)
	if ls == nil then
		vim.notify("BAD", vim.log.levels.ERROR)
		return
	end
	if not config.snippets.enabled then
		return
	end

	setup_cpp(config.snippets.cpp)
end

return M
