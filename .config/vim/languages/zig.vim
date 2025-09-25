let s:settings = {
  \ 'name': 'zls',
  \ 'cmd': {server_info->['zls']},
  \ 'allowlist': ['zig'],
  \}
call SetupLSP(s:settings, 'allowlist', v:true)()
