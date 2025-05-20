# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS', 3)
threads threads_count, threads_count

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Specify the PID file for consistent cleanup
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Bind to all interfaces on the port provided by Fly ($PORT) or default 3000
port        ENV.fetch('PORT', 3000)
bind        "tcp://0.0.0.0:#{ENV.fetch('PORT', 3000)}"

# Environment setup
environment ENV.fetch('RAILS_ENV', 'production')

# Cluster mode (enable if you want multiple workers)
# workers ENV.fetch('WEB_CONCURRENCY', 2)

# Worker boot hook to establish ActiveRecord connection
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
