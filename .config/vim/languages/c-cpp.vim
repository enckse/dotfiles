if !executable('clangd')
    finish
endif
let c_allow = ['c', 'cpp', 'objc', 'objcpp']
augroup lsp_setup
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': {server_info->['clangd']},
                \ 'whitelist': c_allow,
                \ })
augroup end
let g:buffer_comp_ignores = g:buffer_comp_ignores + c_allow
let g:have_clangd = v:true
