let s:settings = {
  \ 'name': 'clangd',
  \ 'cmd': {server_info->['clangd']},
  \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
  \}
if !executable(s:settings['name'])
    finish
endif
augroup lsp_setup
    autocmd!
    autocmd User lsp_setup call lsp#register_server(s:settings)
augroup end
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:settings['whitelist']
let g:buffer_formatting = g:buffer_formatting + s:settings['whitelist']
