" Implementation of agent interface

if exists('g:autoloaded_wecode_agent')
  finish
endif
let g:autoloaded_wecode_agent = 1

"   Stores the job of the current wecode agent node process
let s:wecode = 0

"   Stores the status of the wecode agent
let s:wecode_status = 'notInitialized'

"   Stores the name of issues if any
let s:wecode_issues = []

function! wecode#agent#Status()
  return s:wecode_status
endfunction

function! wecode#agent#Issues()
  return s:wecode_issues
endfunction

function! wecode#agent#Open(command)
  if type(s:wecode) != v:t_number || s:wecode != 0
    return
  endif

  let s:wecode = wecode#job#Start(a:command, #{
    \ out_cb: { _, data -> s:OnNotification(data) },
    \ err_cb: { _, data -> s:OnError(data) },
    \ exit_cb: { _ -> s:OnExit() },
    \ })

  call wecode#agent#Initialize()
endfunction

function! s:OnNotification(data)
  if (type(a:data) == v:t_dict) && has_key(a:data, 'event')
    if  a:data.event == 'statusChanged'
      let s:wecode_status = a:data.status
    elseif a:data.event == 'issuesUpdated'
      let s:wecode_issue = a:data.issues
    endif
  endif
endfunction

function! s:OnError(data)
  " For Debug
  " echoerr "OnError: " . string(a:data)
endfunction

function! s:OnExit()
  let s:wecode = {}
  let s:wecode_status = 'exited'
endfunction

function! wecode#agent#Close()
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Stop(s:wecode)
  let s:wecode = {}
  let s:wecode_status = 'exited'
endfunction

function! wecode#agent#Initialize()
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Send(s:wecode, #{
    \ func: 'initialize',
    \ args: [#{
      \ clientProperties: s:GetClientProperties(),
      \ }],
    \ })
endfunction

function! wecode#agent#RequestAuthUrl(OnResponse)
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Send(s:wecode, #{
    \ func: 'requestAuthUrl',
    \ args: [],
    \ }, #{
    \ callback: { _, data -> a:OnResponse(data) },
    \ })
endfunction

function! wecode#agent#WaitForAuthToken(code)
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Send(s:wecode, #{
    \ func: 'waitForAuthToken',
    \ args: [a:code],
    \ })
endfunction

function! wecode#agent#ProvideCompletions(request, OnResponse)
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  let requestId = wecode#job#Send(s:wecode, #{
    \ func: 'provideCompletions',
    \ args: [a:request, { "signal": v:true }],
    \ }, #{
    \ callback: { _, data -> a:OnResponse(data) },
    \ })
  return requestId
endfunction

function! wecode#agent#CancelRequest(requestId)
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Send(s:wecode, #{
    \ func: 'cancelRequest',
    \ args: [a:requestId],
    \ })
endfunction

function! wecode#agent#PostEvent(event)
  if type(s:wecode) == v:t_number && s:wecode == 0
    return
  endif
  call wecode#job#Send(s:wecode, #{
    \ func: 'postEvent',
    \ args: [a:event],
    \ })
endfunction

function! s:GetClientProperties()
  let version_output = execute('version')
  let client = split(version_output, "\n")[0]
  let name = split(client, ' ')[0]
  return #{
    \ user: #{
      \ vim: #{
        \ triggerMode: g:wecode_trigger_mode
      \ }
    \ },
    \ session: #{
      \ client: client,
      \ ide: #{
        \ name: name,
        \ version: client,
      \ },
      \ tabby_plugin: #{
        \ name: 'FicoHu/vim',
        \ version: g:wecode_version,
      \ },
    \ }
  \ }
endfunction
