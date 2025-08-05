if !executable("lua-language-server")
    finish
endif
let s:lua_allow = ['lua']
au User lsp_setup call lsp#register_server({
    \ 'name': 'lua-language-server',
    \ 'cmd': {server_info->['lua-language-server']},
    \ 'allowlist': s:lua_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:lua_allow
let g:buffer_formatting = g:buffer_formatting + s:lua_allow
