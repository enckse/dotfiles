if !executable("zls")
    finish
endif
let s:zig_allow = ['zig']
au User lsp_setup call lsp#register_server({
    \ 'name': 'zls',
    \ 'cmd': {server_info->['zls']},
    \ 'allowlist': s:zig_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:zig_allow
