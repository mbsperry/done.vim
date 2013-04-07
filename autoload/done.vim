" Done.vim, a simple way to integrate Google Tasks and vim
" Version 0.1.3
" Matthew Sperry, 2012

function! done#StartServer()
  let l:cmd = '../bin/task_server &'
  "  let result = system(l:cmd)
  "  echo "Starting server"
endfunction

function! done#StartTasks()
  let ruby_file = fnameescape(globpath(&runtimepath, 'plugin/done_app.rb')) 
  exe 'rubyfile ' .ruby_file 
  ruby $v = DoneApp.new
endfunction

function! done#SelectList()
  ruby $v.select_tasklist()
endfunction

function! done#ToggleTask()
  ruby $v.toggle_task
endfunction

function! done#SelectTlWindow()
  ruby $v.select_tl_window
  ruby $v.close_task_window
endfunction

function! done#RefreshTasks()
  ruby $v.refresh_tasks
endfunction

function! done#SortTasks()
  ruby $v.sort_tasks
endfunction

function! done#AddTask()
  ruby $v.add_task
endfunction

function! done#DeleteTask()
  ruby $v.delete_task
endfunction

function! done#ChangeTaskName()
  ruby $v.change_task_name
endfunction

function! done#QuitApp()
  ruby $v.quit
endfunction

