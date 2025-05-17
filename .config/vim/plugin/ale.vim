let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_hover_to_preview = 1
let g:ale_linters = {}
if executable("gopls")
  let g:ale_linters.go = ['gopls']
endif
  if executable("shellcheck")
let g:ale_linters.sh = ['shellcheck']
endif
if executable("lua_language_server")
  let g:ale_linters.lua = ["lua_language_server"]
endif
let g:ale_fixers = {}
if executable("gofumpt")
  let g:ale_fixers.go = ["gofumpt"]
endif
let g:ale_completion_delay = 500
