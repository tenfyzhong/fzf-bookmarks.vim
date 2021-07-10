function! s:simplify_path(cwd, path)
  let path = fnamemodify(a:path, ':p')
  let cwdlen = strlen(a:cwd)
  if strlen(path) > cwdlen && path[0:cwdlen-1] == a:cwd
    return path[cwdlen:]
  endif
  return a:path
endfunction

function! s:simplify_paths(cwd, paths)
  let paths = []
  for path in a:paths
    let simplified = <SID>simplify_path(a:cwd, path)
    call add(paths, simplified)
  endfor
  return paths
endfunction

function! fzfbm#run()
  if !exists(':BookmarkShowAll')
    echoerr "fzf-bookmarks.vim: Please install bookmarks.vim first."
    return
  endif
  let cwd = fnamemodify(getcwd(), ':p')
  let items = bm#location_list()
  let paths = <SID>simplify_paths(cwd, items)
  call fzf#run(fzf#wrap({
        \ 'source': paths,
        \ 'sink*': function('fzfbm#callback'),
        \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --prompt "Bookmarks > "',
        \ }))
endfunction

function! fzfbm#callback(item)
  if len(a:item) < 2
    return
  endif
  let cmd = get(
        \ {'ctrl-x': 'split', 
        \  'ctrl-v': 'vsplit',
        \  'ctrl-t': 'tabedit'}, a:item[0], 'e')
  let content = split(a:item[1], ':')
  if len(content) < 2
    return
  endif
  let file = content[0]
  let line = content[1]
  execute printf('silent %s +%s %s', cmd, line, file)
endfunction
