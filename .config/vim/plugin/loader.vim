let plugin_set = {}
let plugin_set['vim-airline'] = 'https://github.com/vim-airline/'
let plugin_set['asyncomplete-buffer.vim'] = 'https://github.com/prabirshrestha/'
let plugin_set['asyncomplete-lsp.vim'] = 'https://github.com/prabirshrestha/'
let plugin_set['asyncomplete.vim'] = 'https://github.com/prabirshrestha/'
let plugin_set['vim-lsp'] = 'https://github.com/prabirshrestha/'
let plugin_set['vim-qf-diagnostics'] = 'https://github.com/bfrg/'
let plugin_set['vim-shellcheck'] = 'https://github.com/itspriddle/'
let needs_plugin_load = v:false
let g:plugin_dirs = []
for key in keys(plugin_set)
    let directory = $HOME . '/.config/vim/pack/plugins/start/' . key
    let repo = plugin_set[key] . key
    if ! isdirectory(directory)
        echo "cloning " . repo
        execute 'silent !git clone --quiet ' . repo . " " . directory
        let needs_plugin_load = v:true
    endif
    call insert(g:plugin_dirs, directory, 0)
endfor
function NeedRestart()
    echo "plugins need to load, quitting in a moment..."
    sleep 3
    quit
endfunction
if needs_plugin_load
    call NeedRestart()
endif
function! UpdatePlugins()
    let need_quit = v:false
    for repo in g:plugin_dirs
        echomsg "updating " . repo
        let hasher = "git -C " . repo . " log -n 1 --format=%h"
        let was = trim(system(hasher))
        call system("git -C " . repo . " pull --quiet")
        let now = trim(system(hasher))
        echomsg "was " . was . ", now " . now
        if was != now
            need_quit = v:true
        endif
        echomsg "done"
    endfor
    if need_quit
        call NeedRestart()
    endif
endfunction
command! UpdatePlugins :call UpdatePlugins()
