require 'drb/drb'

class VimHelper

  def get_server()
    server_uri ="druby://localhost:8787"
    DRb.start_service("druby://localhost:0")
    @task_server = DRbObject.new_with_uri(server_uri)
  end

  def initialize()
    get_server()

    VIM.command "botright new TASKS"
    @buffer = VIM::Buffer.current

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

  def unlock()
    VIM::command "setlocal modifiable"
    # clear screen
    VIM::command "silent %d _"
  end

  def lock()
    VIM::command "setlocal nomodifiable"

    # Hide the cursor
    VIM::command "normal! Gg$"
  end

  def print_tasklists()
    self.unlock
      titles = @task_server.get_tasklist_titles()
      titles.each do |title|
        @buffer.append(@buffer.count-1, title)
      end
    self.lock
  end

  def select_tasklist()
    tl_index = @buffer.line_number - 1
    self.unlock
    lines = @task_server.get_task_lines(tl_index).reverse
    lines.each { |l| @buffer.append(0, l) }
    self.lock
  end

end

