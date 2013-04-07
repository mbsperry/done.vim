" Done.vim, a simple way to integrate Google Tasks and vim
" Version 0.1.3
" Matthew Sperry, 2012

function! StartServer()
  let l:cmd = '../bin/task_server &'
"  let result = system(l:cmd)
"  echo "Starting server"
endfunction

function! BasicMappings()
  exec "nnoremap <silent> <leader>t :call StartTasks()<CR>"
  exec "nnoremap <silent> <leader>rl :source task_app.vim<CR>"
  exec "nnoremap <silent> <leader>q :call QuitApp()<CR>"
endfunction
   
"function! ApplyMappings()
  "exec "nnoremap <silent> <buffer> <CR> :call SelectList()<CR>"
"endfunction

function! StartTasks()
  let ruby_file = fnameescape(globpath(&runtimepath, 'plugin/done_app.rb')) 
  exe 'rubyfile ' .ruby_file 
  ruby << EOF
    $v = DoneApp.new
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
  ruby $v.close_task_window
endfunction

function! RefreshTasks()
  ruby $v.refresh_tasks
endfunction

function! SortTasks()
  ruby $v.sort_tasks
endfunction

function! AddTask()
  ruby $v.add_task
endfunction

function! DeleteTask()
  ruby $v.delete_task
endfunction

function! ChangeTaskName()
  ruby $v.change_task_name
endfunction

function! QuitApp()
  ruby $v.quit
endfunction

command! Tasks :call StartTasks()
command! RefreshTasks :call RefreshTasks()
command! SortTasks :call SortTasks()
command! AddTask :call AddTask()
command! QuitTasks :call QuitApp()

call BasicMappings()
call StartServer()
