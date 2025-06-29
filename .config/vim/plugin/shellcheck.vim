def RunShellCheck()
    if &ft ==# 'sh'
        setlocal signcolumn=yes
        exe ":DiagnosticsClear"
        exe ":ShellCheck"
        exe ":DiagnosticsToggle"
    endif
enddef

autocmd BufWrite,BufEnter * call RunShellCheck()
autocmd FileType sh nnoremap <buffer> <C-e> :copen<CR>
