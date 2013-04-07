require 'drb/drb'

class DoneApp

  attr_accessor :tl_index, :tl_window, :task_window

  def get_server
    server_uri ="druby://localhost:8787"
    DRb.start_service("druby://localhost:0")
    @task_server = DRbObject.new_with_uri(server_uri)
  end

  def initialize
    get_server()

    make_tl_window()
    setup_buffer()
    tasklist_mappings()

    print_tasklists()
    @tl_window.cursor = [0,0]

    make_task_window()
    select_tasklist()

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

  def make_tl_window
    VIM.command "botright new TASKSLISTS"
    @tl_window = $curwin
    @tl_buffer = VIM::Buffer.current
  end

  def make_task_window
    VIM.command "belowright vne TASKS"
    @task_window = $curwin
    @task_buffer = $curbuf
    setup_buffer
    task_mappings()
  end

  def get_win_number(window)
    c = VIM::Window.count
    # Ruby vim bindings have weirdness. vimscript commands use window
    # numbers starting at 1. But the VIM::Window[] returns windows starting at 0.
    0.upto(c-1) do |n|
      return n+1 if window == VIM::Window[n]
    end
    return false
  end

  def close_window(window)
    win_num = get_win_number(window)
    if win_num
      VIM::command "#{win_num} wincmd w"
      VIM::command "q!"
    end
  end

  def select_window(window)
    win_num = get_win_number(window)
    VIM::command "#{win_num} wincmd w"
  end

  def select_tl_window
    select_window(@tl_window)
  end

  def close_task_window
    close_window(@task_window)
  end

  def quit
    close_window(@task_window)
    close_window(@tl_window)
  end

  def map_key(key, function)
    cmd = "nnoremap <silent> <buffer> #{key} :call #{function}()<CR>"
    VIM::command cmd
  end
  
  def tasklist_mappings
    map_key("<CR>", "SelectList")
    map_key("l", "SelectList")
  end

  def task_mappings
    map_key("<space>", "ToggleTask")
    map_key("h", "SelectTlWindow")
    map_key("dd", "DeleteTask")
    map_key("i", "AddTask")
    map_key("c", "ChangeTaskName")
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

  def select_tasklist
    @tl_index = @tl_window.cursor[0] - 1
    unless get_win_number(@task_window)
      make_task_window()
    end
    refresh_tasks()
  end

  def refresh_tasks
    select_window(@task_window)
    self.unlock
    lines = @task_server.get_task_lines(@tl_index).reverse
    lines.each { |l| @task_buffer.append(0, l) }
    self.lock
    @task_window.cursor = [0,0]
  end

  def sort_tasks
    @task_server.sort_tasks(@tl_index)
    refresh_tasks
  end

  def toggle_task
    task_index = @task_buffer.line_number - 1
    @task_server.toggle_status(task_index, @tl_window.cursor[0]-1)
    refresh_tasks()
    $curwin.cursor = [task_index+1, 0]
  end
  
  def input(msg)
    VIM.command "call inputsave()"
    VIM.command "let user_input = input('#{msg} ')"
    VIM.command "call inputrestore()"
    VIM.evaluate "user_input"
  end

  def add_task
    task_name = input("New task name:")
    @task_server.new_task(task_name, @tl_index)
    refresh_tasks()
  end

  def delete_task
    task_index = @task_buffer.line_number - 1
    @task_server.delete_task(task_index, @tl_window.cursor[0]-1)
    refresh_tasks()
    $curwin.cursor = [task_index+1, 0]
  end

  def change_task_name()
    task_index = @task_buffer.line_number - 1
    update_hash = {"title" => input("New task name:")}
    @task_server.update_at_index(task_index, @tl_window.cursor[0]-1, update_hash)
    refresh_tasks()
    $curwin.cursor = [task_index+1, 0]
  end

end

