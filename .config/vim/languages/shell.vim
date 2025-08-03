if !executable("shellcheck")
  finish
endif

function! s:update_error(val, current)
  return extend(a:val, { 'bufnr': a:current })
endfunction

function! s:shellcheck() abort
  let old_errorformat = &errorformat
  try
    let current_file = expand("%")
    let current_bufnr = bufnr("%")
    let title = join(filter(["ShellCheck", current_file], "len(v:val)"))
    let cmd = join(filter(["shellcheck -x -f gcc", shellescape(current_file)], "len(v:val)"))
    let &errorformat = 
            \ '%f:%l:%c: %trror: %m [SC%n],' .
            \ '%f:%l:%c: %tarning: %m [SC%n],' .
            \ '%I%f:%l:%c: %tote: %m [SC%n],' .
            \ '%-G%.%#'

    execute "silent cgetexpr system(cmd)"

    let errors = map(getqflist(), "s:update_error(v:val, current_bufnr)")
    call setqflist([], "r", { "items": errors, "title": title })
  finally
    let &errorformat = old_errorformat
  endtry
endfunction

def RunShellCheck()
    if &ft ==# 'sh'
        setlocal signcolumn=yes
        exe ":DiagnosticsClear"
        call s:shellcheck()
        exe ":DiagnosticsToggle"
    endif
enddef

let g:qfdiagnostics = {
            \'virttext': v:true
            \}
autocmd BufWritePost,BufEnter * call RunShellCheck()
autocmd FileType sh nnoremap <buffer> <C-e> :copen<CR>
