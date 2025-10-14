let s:ty_settings = {
  \ 'name': 'ty',
  \ 'cmd': {server_info->['ty', 'server']},
  \ 'allowlist': ['python']
  \}
call SetupLSP(s:ty_settings, 'allowlist', v:true)()
let s:ruff_settings = {
  \ 'name': 'ruff',
  \ 'cmd': {server_info->['ruff', 'server']},
  \ 'allowlist': ['python']
  \ }
call SetupLSP(s:ruff_settings, 'allowlist', v:true)()
