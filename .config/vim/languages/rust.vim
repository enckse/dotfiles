if !executable("rust-analyzer")
    finish
endif
let s:rust_allow = ['rust']
au User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': {server_info->['rust-analyzer']},
    \ 'whitelist': s:rust_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:rust_allow
let g:buffer_formatting = g:buffer_formatting + s:rust_allow
