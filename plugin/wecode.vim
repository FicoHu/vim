if exists('g:loaded_wecode')
  finish
endif
let g:loaded_wecode = 1

command! -nargs=* -complete=customlist,wecode#commands#Complete Wecode call wecode#commands#Main(<q-args>)
silent! execute 'helptags' fnameescape(expand('<sfile>:h:h') . '/doc')

augroup wecode
  autocmd!
  autocmd VimEnter                      *  call wecode#OnVimEnter()
  autocmd VimLeave                      *  call wecode#OnVimLeave()
  autocmd TextChangedI,CompleteChanged  *  call wecode#OnTextChanged()
  autocmd CursorMovedI                  *  call wecode#OnCursorMoved()
  autocmd InsertLeave,BufLeave          *  call wecode#OnInsertLeave()
augroup END
