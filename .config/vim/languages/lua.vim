let s:settings = {
  \ 'name': 'lua-language-server',
  \ 'cmd': {server_info->['lua-language-server']},
  \ 'allowlist': ['lua'],
  \}
if !executable(s:settings['name'])
    finish
endif
au User lsp_setup call lsp#register_server(s:settings)
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:settings['allowlist']
let g:buffer_formatting = g:buffer_formatting + s:settings['allowlist']
