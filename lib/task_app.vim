function! StartServer()
  let l:cmd = '../bin/task_server &'
"  let result = system(l:cmd)
  echo "Starting server"
endfunction

function! BasicMappings()
  exec "nnoremap <silent> <leader>t :call StartTasks()<CR>"
  exec "nnoremap <silent> <leader>rl :source task_app.vim<CR>"
  exec "nnoremap <silent> <leader>tl :call SelectTlWindow()<CR>"
endfunction
   
"function! ApplyMappings()
  "exec "nnoremap <silent> <buffer> <CR> :call SelectList()<CR>"
"endfunction

function! StartTasks()
  rubyfile vim_helper.rb
  ruby << EOF
    $v = VimHelper.new
EOF
  "call ApplyMappings()
endfunction

function! SelectList()
  ruby $v.select_tasklist()
endfunction

function! ToggleTask()
  ruby $v.toggle_task
endfunction

function! SelectTlWindow()
  ruby $v.select_tl_window
endfunction

function! QuitApp()
  ruby $v.quit
endfunction

command! Tasks :call StartTasks()
command! QuitTasks :call QuitApp()

call BasicMappings()
call StartServer()
