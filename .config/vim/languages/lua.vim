let s:settings = {
  \ 'name': 'lua-language-server',
  \ 'cmd': {server_info->['lua-language-server']},
  \ 'allowlist': ['lua'],
  \}
call SetupLSP(s:settings, 'allowlist', v:true)()
