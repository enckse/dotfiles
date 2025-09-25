let g:buffer_comp_ignores = []
let g:buffer_formatting = []

let g:lsp_configurations = {}

let g:lsp_fold_enabled = 0
let g:lsp_completion_documentation_delay = 500
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_align = "right"
let g:asyncomplete_popup_delay = 500

function! FormatCode()
    for formatter in g:buffer_formatting
        if &filetype == formatter
            call execute('LspDocumentFormatSync')
            return
        endif
    endfor
endfunction

function! s:on_lsp_buffer_enabled() abort
    nnoremap <C-e> :LspDocumentDiagnostics<CR>
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre * call FormatCode()
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

function! SetupLSP(settings, allow, format)
  if !executable(a:settings['name'])
    function! EmptyLSP()
    endfunction
    return funcref('EmptyLSP')
  endif
  let g:lsp_configurations[a:settings['name']] = deepcopy(a:settings)
  function! ConfigureLSP() closure
    execute 'au User lsp_setup call lsp#register_server(g:lsp_configurations["' . a:settings['name'] . '"])'
    let g:buffer_comp_ignores = g:buffer_comp_ignores + a:settings[a:allow]
    if a:format
      let g:buffer_formatting = g:buffer_formatting + a:settings[a:allow]
    endif
  endfunction
  return funcref('ConfigureLSP')
endfunction

let s:langs = expand('~/.config/vim/languages')
if isdirectory(s:langs)
  for s:file in split(glob(s:langs . '/*'), '\n')
    execute 'source' s:file
  endfor
endif
