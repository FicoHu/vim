" Commands for Wecode

if exists('g:autoloaded_wecode_commands')
  finish
endif
let g:autoloaded_wecode_commands = 1


" See `*Wecode-commands*` section in `doc/wecode.txt` for more details.

"   A dictionary contains all commands. Use name as key and function as value.
let s:commands = {}

function! s:commands.status(...)
  call wecode#Status()
endfunction

function! s:commands.version(...)
  echo g:wecode_version
endfunction

function! s:commands.help(...)
  let args = get(a:, 1, [])
  if len(args) < 1
    execute 'help Wecode'
    return
  endif
  try
    execute 'help Wecode-' . join(args, '-')
    return
  catch
  endtry
  try
    execute 'help wecode_' . join(args, '_')
    return
  catch
  endtry
  execute 'help Wecode'
endfunction

function! wecode#commands#Main(args)
  let args = split(a:args, ' ')
  if len(args) < 1
    call wecode#Status()
    echo 'Use `:help Wecode` to see available commands.'
    return
  endif
  if has_key(s:commands, args[0])
    call s:commands[args[0]](args[1:])
  else
    echo 'Unknown command.'
    echo 'Use `:help Wecode` to see available commands.'
  endif
endfunction

function! wecode#commands#Complete(arglead, cmd, pos)
  let words = split(a:cmd[0:a:pos].'#', ' ')
  if len(words) > 3
    return []
  endif
  if len(words) == 3
    if words[1] == 'help'
      let candidates = ['compatibility', 'commands', 'options', 'keybindings']
    else
      return []
    endif
  else
    let candidates = keys(s:commands)
  endif

  let end_index = len(a:arglead) - 1
  if end_index < 0
    return candidates
  else
    return filter(candidates, { idx, val -> val[0:end_index] == a:arglead })
  endif
endfunction
