function! UpdatePlugins()
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
endfunction

command! UpdatePlugins call UpdatePlugins()
