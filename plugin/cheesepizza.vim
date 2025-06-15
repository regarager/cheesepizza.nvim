if exists("g:loaded_cheesepizza")
    finish
endif

let g:loaded_cheesepizza = 1

let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/example-plugin/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"
