require 'drb/drb'

class VimHelper

  attr_accessor :tl_index

  def get_server
    server_uri ="druby://localhost:8787"
    DRb.start_service("druby://localhost:0")
    @task_server = DRbObject.new_with_uri(server_uri)
  end

  def initialize
    get_server()

    VIM.command "botright new TASKSLISTS"
    @tl_buffer = VIM::Buffer.current
    setup_buffer()
    tasklist_mappings()
  end

  def setup_buffer
    VIM::command "setlocal bufhidden=delete"
    VIM::command "setlocal buftype=nofile"
    VIM::command "setlocal nomodifiable"
    VIM::command "setlocal noswapfile"
    VIM::command "setlocal nowrap"
    VIM::command "setlocal nonumber"
    VIM::command "setlocal foldcolumn=0"
    VIM::command "setlocal nocursorline"
    VIM::command "setlocal nospell"
    VIM::command "setlocal nobuflisted"
    VIM::command "setlocal textwidth=0"
    VIM::command "setlocal noreadonly"
    VIM::command "setlocal cursorline"
  end

  def map_key(key, function)
    cmd = "nnoremap <silent> <buffer> <#{key.to_s}> :call #{function}()<CR>"
    VIM::command cmd
  end
  
  def tasklist_mappings
    map_key(:CR, "SelectList")
    #VIM::command "nnoremap <silent> <buffer> <CR> :call SelectList()<CR>"
  end

  def task_mappings
    map_key(:space, "ToggleTask")
  end

  def task_window
    VIM.command "belowright vne TASKS"
    @task_buffer = VIM::Buffer.current
    setup_buffer
    task_mappings()
  end

  def unlock
    VIM::command "setlocal modifiable"
    # clear screen
    VIM::command "silent %d _"
  end

  def lock
    VIM::command "setlocal nomodifiable"

    # Hide the cursor
    VIM::command "normal! Gg$"
  end

  def print_tasklists
    self.unlock
      titles = @task_server.get_tasklist_titles()
      titles.each do |title|
        @tl_buffer.append(@tl_buffer.count-1, title)
      end
    self.lock
  end

  def refresh_tasks
    self.unlock
    lines = @task_server.get_task_lines(@tl_index).reverse
    lines.each { |l| @task_buffer.append(0, l) }
    self.lock
  end

  def select_tasklist
    @tl_index = @tl_buffer.line_number - 1
    task_window()
    refresh_tasks()
  end

  def toggle_task
    task_index = @task_buffer.line_number - 1
    @tl_index = @tl_buffer.line_number - 1
    puts "Task: #{task_index}, TL: #{@tl_index}"
    #@task_server.toggle_status(task_index, @tl_index)
    #refresh_tasks(@tl_index)
  end

end

