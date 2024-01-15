
" Global variables of Wecode plugin. Include options and internal variables.

if exists('g:autoloaded_wecode_globals')
  finish
endif

function! wecode#globals#Load()
  let g:autoloaded_wecode_globals = 1

  " See *Wecode-options* section in `doc/wecode.txt` for more details about options.

  " The trigger mode of compleiton, default is "auto".
  " - auto: Wecode automatically show inline completion when you stop typing.
  " - manual: You need to press <C-\> to show inline completion.
  let g:wecode_trigger_mode = get(g:, 'wecode_trigger_mode', 'auto')


  " Wecode requires Node.js version 18.0 or higher to run the wecode agent.
  " Specify the binary of Node.js, default is "node", which means search in $PATH.
  let g:wecode_node_binary = get(g:, 'wecode_node_binary', 'node')

  " The script of wecode agent.
  let g:wecode_node_script = expand('<script>:h:h:h') . '/node_scripts/wecode-agent.js'


  " Wecode use `getbufvar('%', '&filetype')` to get filetype of current buffer, and
  " then use `g:wecode_filetype_dict` to map it to language identifier.
  " From: vim filetype https://github.com/vim/vim/blob/master/runtime/filetype.vim
  " To: vscode language identifier https://code.visualstudio.com/docs/languages/identifiers#_known-language-identifiers
  " Not listed filetype will be used as language identifier directly.
  let s:default_filetype_dict = #{
    \ bash: "shellscript",
    \ sh: "shellscript",
    \ cs: "csharp",
    \ objc: "objective-c",
    \ objcpp: "objective-cpp",
    \ make: "makefile",
    \ cuda: "cuda-cpp",
    \ text: "plaintext",
    \ }
  let g:wecode_filetype_dict = get(g:, 'wecode_filetype_dict', {})
  let g:wecode_filetype_dict = extend(s:default_filetype_dict, g:wecode_filetype_dict)

  " Keybinding of accept completion, default is "<Tab>".
  let g:wecode_keybinding_accept = get(g:, 'wecode_keybinding_accept', '<Tab>')

  " Keybinding of trigger or dismiss completion, default is "<C-\>".
  let g:wecode_keybinding_trigger_or_dismiss = get(g:, 'wecode_keybinding_trigger_or_dismiss', '<C-\>')


  " Version of Wecode plugin. Not configurable.
  let g:wecode_version = "1.2.0"
endfunction