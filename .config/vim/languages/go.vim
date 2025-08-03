if !executable('gopls')
    finish
endif
let s:go_allow = ['go']
au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'allowlist': s:go_allow,
    \ 'initialization_options': {
    \     'staticcheck': v:true,
    \     'gofumpt': v:true,
    \ },
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:go_allow
let g:buffer_formatting = g:buffer_formatting + s:go_allow
