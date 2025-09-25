let s:settings = {
  \ 'name': 'rust-analyzer',
  \ 'cmd': {server_info->['rust-analyzer']},
  \ 'whitelist': ['rust'],
  \}
if !executable(s:settings['name'])
    finish
endif
au User lsp_setup call lsp#register_server(s:settings)
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:settings['whitelist']
let g:buffer_formatting = g:buffer_formatting + s:settings['whitelist']
