let s:settings = {
  \ 'name': 'gopls',
  \ 'cmd': {server_info->['gopls']},
  \ 'allowlist': ['go'],
  \ 'initialization_options': {
  \     'staticcheck': v:true,
  \     'gofumpt': v:true,
  \ }
  \}
call SetupLSP(s:settings, 'allowlist', v:true)()
