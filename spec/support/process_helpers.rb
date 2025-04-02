# frozen_string_literal: true

module ProcessHelpers
  def loop_script_path = File.expand_path("loop", __dir__)

  def loop_script(prefix: nil)
    loop_command = [prefix, loop_script_path].compact.join(" ")
    holder = []
    pid = Process.spawn(loop_command)
    Signal.trap("SIGUSR1") do
      holder[0] = yield(pid)
      Process.kill("SIGTERM", pid)
    end
    Process.wait(pid)
    holder[0]
  end
end
