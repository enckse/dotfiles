function! MyBufferline()
  let s = ''
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
  for b in buffers
    let buflist = getbufinfo(b)
    let buffer_name = fnamemodify(buflist[0].name, ':t')

    " current buffer
    if b == bufnr('%')
      let s .= '%1*'
      let s .= '[ '
    else
      let s .= '%2*'
      let s .= '  '
    endif

    let s .= b . ': ' . (buffer_name != '' ? buffer_name : '[No Name]') . ' '

    if b == bufnr('%')
      let s .= ']'
    else
      let s .= ' '
    endif

    if b != buffers[-1]
      let s .= '|'
    endif
  endfor

  let s .= '%T' . '%999X'

  return s
endfunction

" Set the statusline to use our new function
set laststatus=2
set showtabline=2
set tabline=%!MyBufferline()
