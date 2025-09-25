let s:settings = {
  \ 'name': 'rust-analyzer',
  \ 'cmd': {server_info->['rust-analyzer']},
  \ 'whitelist': ['rust'],
  \}
call SetupLSP(s:settings, 'whitelist', v:true)()
