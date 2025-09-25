let s:settings = {
  \ 'name': 'zls',
  \ 'cmd': {server_info->['zls']},
  \ 'allowlist': ['zig'],
  \}
if !executable(s:settings['name'])
    finish
endif
au User lsp_setup call lsp#register_server(s:settings)
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:settings['allowlist']
