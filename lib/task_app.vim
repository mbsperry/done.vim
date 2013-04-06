function! StartServer()
  let l:cmd = '../bin/task_server &'
"  let result = system(l:cmd)
  echo "Starting server"
endfunction

function! BasicMappings()
  exec "nnoremap <silent> <leader>t :call StartTasks()<CR>"
  exec "nnoremap <silent> <leader>rl :source task_app.vim<CR>"
endfunction
   
"function! ApplyMappings()
  "exec "nnoremap <silent> <buffer> <CR> :call SelectList()<CR>"
"endfunction

function! StartTasks()
  rubyfile vim_helper.rb
  ruby << EOF
    $v = VimHelper.new
    $v.print_tasklists
EOF
  "call ApplyMappings()
endfunction

function! SelectList()
  ruby << EOF
  $v.select_tasklist()
EOF
endfunction

function! ToggleTask()
  ruby << EOF
  $v.toggle_task
EOF
endfunction

call BasicMappings()
call StartServer()
