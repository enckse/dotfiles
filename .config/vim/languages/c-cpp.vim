if !executable('clangd')
    finish
endif
let s:c_allow = ['c', 'cpp', 'objc', 'objcpp']
augroup lsp_setup
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd']},
                \ 'whitelist': s:c_allow,
                \ })
augroup end
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:c_allow
let g:buffer_formatting = g:buffer_formatting + s:c_allow
