let s:settings = {
  \ 'name': 'gopls',
  \ 'cmd': {server_info->['gopls']},
  \ 'allowlist': ['go'],
  \ 'initialization_options': {
  \     'staticcheck': v:true,
  \     'gofumpt': v:true,
  \ }
  \}
if !executable(s:settings['name'])
    finish
endif
au User lsp_setup call lsp#register_server(s:settings)
let g:buffer_comp_ignores = g:buffer_comp_ignores + s:settings['allowlist']
let g:buffer_formatting = g:buffer_formatting + s:settings['allowlist']
