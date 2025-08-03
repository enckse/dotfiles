if !executable("lua-language-server")
    finish
endif
let lua_allow = ['lua']
au User lsp_setup call lsp#register_server({
    \ 'name': 'lua-language-server',
    \ 'cmd': {server_info->['lua-language-server']},
    \ 'allowlist': lua_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + lua_allow
