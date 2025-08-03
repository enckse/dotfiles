if !executable('gopls')
    finish
endif
let go_allow = ['go']
au User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'allowlist': go_allow,
    \ 'initialization_options': {
    \     'staticcheck': v:true,
    \     'gofumpt': v:true,
    \ },
    \ })
let g:buffer_comp_ignores = g:buffer_comp_ignores + go_allow
let g:have_gopls = v:true
