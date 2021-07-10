if version < 802
  echoerr "fzf-bookmarks.vim: Please upgrade your vim to 8.2"
  finish
endif

if exists('g:loaded_fzf_bookmarks_vim')
  finish
endif
const g:loaded_fzf_bookmarks_vim = 1

let s:cpo_save = &cpo
set cpo&vim

command! FZFBookmarks call fzfbm#run()

let &cpo = s:cpo_save
unlet s:cpo_save
