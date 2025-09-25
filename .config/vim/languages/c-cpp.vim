let s:settings = {
  \ 'name': 'clangd',
  \ 'cmd': {server_info->['clangd']},
  \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
  \}
call SetupLSP(s:settings, 'whitelist', v:true)()
