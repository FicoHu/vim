" Keybindings for Wecode

if exists('g:autoloaded_wecode_keybindings')
  finish
endif
let g:autoloaded_wecode_keybindings = 1

function! wecode#keybindings#Map()
  " map `wecode#Accept`
  if toupper(g:wecode_keybinding_accept) == '<TAB>'
    " to solve <Tab> binding conflicts, we store the original <Tab> mapping and fallback to it when wecode completions is not shown
    if !empty(mapcheck('<Tab>', 'i'))
      " fallback to the original <Tab> mapping
      let tab_maparg = maparg('<Tab>', 'i', 0, 1)
      let tab_maparg_rhs = get(tab_maparg, 'rhs', '')
      if empty(tab_maparg_rhs) || toupper(tab_maparg_rhs) == '<NOP>'
        " if the original <Tab> mapping is <nop>, no need to fallback
        imap <script><silent><nowait><expr> <Tab> wecode#Accept()
      else
        " warp as function if rhs is expr, otherwise encode rhs as json
        let fallback_rhs = get(tab_maparg, 'expr') ? '{ -> ' . tab_maparg_rhs . ' }' : substitute(json_encode(tab_maparg_rhs), '<', '\\<', 'g')
        " inject <SID>
        let fallback_rhs = substitute(fallback_rhs, '<SID>', "\<SNR>" . get(tab_maparg, 'sid') . '_', 'g')
        exec 'imap ' . (get(tab_maparg, 'script') ? '<script>' : '') . '<silent><nowait><expr> <Tab> wecode#Accept(' . fallback_rhs . ')'
      endif
    else
      " fallback to input \t
      imap <script><silent><nowait><expr> <Tab> wecode#Accept("\t")
    endif
  else
    if !empty(g:wecode_keybinding_accept)
      " map directly without fallback if the user has set keybinding to other than <Tab>
      exec 'imap <script><silent><nowait><expr> ' . g:wecode_keybinding_accept . ' wecode#Accept()'
    endif
  endif

  if !empty(g:wecode_keybinding_trigger_or_dismiss)
    " map `wecode#TriggerOrDismiss`, default to <C-\>
    exec 'imap <script><silent><nowait><expr> ' . g:wecode_keybinding_trigger_or_dismiss . ' wecode#TriggerOrDismiss()'
  endif
endfunction
