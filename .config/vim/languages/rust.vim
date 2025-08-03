if !executable("rust-analyzer")
    finish
endif
let rust_allow = ['rust']
au User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': {server_info->['rust-analyzer']},
    \ 'whitelist': rust_allow,
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + rust_allow
let g:have_rustanalyzer = v:true
