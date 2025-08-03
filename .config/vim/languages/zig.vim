if !executable("zls")
    finish
endif
let zig_allow = ['zig']
au User lsp_setup call lsp#register_server({
    \ 'name': 'zls',
    \ 'cmd': {server_info->['zls']},
    \ 'allowlist': zig_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + zig_allow
