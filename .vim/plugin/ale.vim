let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 500
let g:ale_detail_to_floating_preview = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_hover_to_preview = 1
let g:ale_linters = {}
let g:ale_fixers = {}
function! AddAleHandler(linter, exe, type, tool)
    if executable(a:exe)
        if a:linter
            let g:ale_linters[a:type] = [a:tool]
        else
            let g:ale_fixers[a:type] = [a:tool]
        endif
    endif
endfunction

call AddAleHandler(v:true, "gopls", "go", "gopls")
call AddAleHandler(v:true, "lua-language-server", "lua", "lua_language_server")
call AddAleHandler(v:true, "shellcheck", "sh", "shellcheck")
call AddAleHandler(v:false, "gofumpt", "go", "gofumpt")
call AddAleHandler(v:false, "stylua", "lua", "stylua")
