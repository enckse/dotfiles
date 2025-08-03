let g:buffer_comp_ignores = []

let g:lsp_fold_enabled = 0
let g:lsp_completion_documentation_delay = 500
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "right"
let g:asyncomplete_popup_delay = 500

function! s:on_lsp_buffer_enabled() abort
    nnoremap <C-e> :LspDocumentDiagnostics<CR>
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    let g:lsp_format_sync_timeout = 1000
    if exists("g:have_clangd")
        autocmd! BufWritePre **.c,**.cpp,**.h,**.hpp call execute('LspDocumentFormatSync')
    endif
    if exists("g:have_gopls")
        autocmd! BufWritePre **.go call execute('LspDocumentFormatSync')
    endif
    if exists("g:have_rustanalyzer")
        autocmd! BufWritePre **.rs call execute('LspDocumentFormatSync')
    endif
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': g:buffer_comp_ignores,
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

autocmd VimEnter * :doautocmd BufWinEnter

let s:langs = expand('~/.config/vim/languages')
if isdirectory(s:langs)
  for s:file in split(glob(s:langs . '/*'), '\n')
    execute 'source' s:file
  endfor
endif
