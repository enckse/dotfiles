def RunShellCheck()
    if &ft ==# 'sh'
        setlocal signcolumn=yes
        exe ":DiagnosticsClear"
        exe ":ShellCheck"
        exe ":DiagnosticsToggle"
    endif
enddef

let g:qfdiagnostics = {
            \'virttext': v:true
            \}
autocmd BufWrite,BufEnter * call RunShellCheck()
autocmd FileType sh nnoremap <buffer> <C-e> :copen<CR>
