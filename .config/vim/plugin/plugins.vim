function! UpdatePlugins(notify, force)
  let l:check_file = g:workingdir . '/update.check'
  let l:need_updates = v:true
  if filereadable(l:check_file)
    let l:check = system("find '" . l:check_file . "' -type f -mtime -7")
    if l:check =~ l:check_file
      let l:need_updates = v:false
    endif
  endif
  if a:notify
    if l:need_updates
      echomsg
      echomsg "======================"
      echomsg "plugin update required"
      echomsg "======================"
      echomsg
    endif
    return
  endif
  if !a:force && !l:need_updates
    return
  endif
  let l:install_dir = $HOME . '/.config/vim/pack/plugin/start'
  call system("mkdir -p '" . l:install_dir . "'")
  let l:plugins = ["https://github.com/vim-airline/vim-airline",
              \    "https://github.com/prabirshrestha/asyncomplete-buffer.vim",
              \    "https://github.com/prabirshrestha/asyncomplete-lsp.vim",
              \    "https://github.com/prabirshrestha/asyncomplete.vim",
              \    "https://github.com/prabirshrestha/vim-lsp",
              \    "https://github.com/bfrg/vim-qf-diagnostics"]
  for i in l:plugins
    let l:bname = fnamemodify(i, ":t")
    echomsg "updating plugin: " . l:bname
    let l:dir = l:install_dir . "/" . l:bname
    call system("test ! -d '" . l:dir . "' && git clone '" . i . "' '" . l:dir . "'")
    call system("git -C '" . l:dir . "' pull")
  endfor
  call system("touch '" . l:check_file ."'")
  quit
endfunction

command! UpdatePlugins call UpdatePlugins(v:false, v:false)
command! UpdatePluginsForce call UpdatePlugins(v:false, v:true)
call UpdatePlugins(v:true, v:false)
