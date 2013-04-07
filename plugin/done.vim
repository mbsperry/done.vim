" Done.vim, a simple way to integrate Google Tasks and vim
" Version 0.1.3
" Matthew Sperry, 2012

function! BasicMappings()
  exec "nnoremap <silent> <leader>t :call done#StartTasks()<CR>"
  exec "nnoremap <silent> <leader>rl :source done#task_app.vim<CR>"
  exec "nnoremap <silent> <leader>q :call done#QuitApp()<CR>"
endfunction
   
command! Tasks :call done#StartTasks()
command! RefreshTasks :call done#RefreshTasks()
command! SortTasks :call done#SortTasks()
command! AddTask :call done#AddTask()
command! QuitTasks :call done#QuitApp()

call BasicMappings()
" call StartServer()
