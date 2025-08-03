let buffer_ignores = []
if executable('gopls')
    let go_allow = ['go']
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'allowlist': go_allow,
        \ 'initialization_options': {
        \     'staticcheck': v:true,
        \     'gofumpt': v:true,
        \ },
        \ })
    let buffer_ignores = buffer_ignores + go_allow
endif
if executable("lua-language-server")
    let lua_allow = ['lua']
    au User lsp_setup call lsp#register_server({
        \ 'name': 'lua-language-server',
        \ 'cmd': {server_info->['lua-language-server']},
        \ 'allowlist': lua_allow,
        \ })
    let buffer_ignores = buffer_ignores + lua_allow
endif
if executable("zls")
    let zig_allow = ['zig']
    au User lsp_setup call lsp#register_server({
        \ 'name': 'zls',
        \ 'cmd': {server_info->['zls']},
        \ 'allowlist': zig_allow,
        \ })
    let buffer_ignores = buffer_ignores + zig_allow
endif
if executable('clangd')
    let c_allow = ['c', 'cpp', 'objc', 'objcpp']
    augroup lsp_setup
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': c_allow,
                    \ })
    augroup end
    let buffer_ignores = buffer_ignores + c_allow
endif

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
    autocmd! BufWritePre **.go,**.c,**.cpp,**.h,**.hpp call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': buffer_ignores,
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

autocmd VimEnter * :doautocmd BufWinEnter
