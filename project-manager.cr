# name = ARGV.shift || abort("Usage: #$0 project_name")
# args = Array.new
# ports = %W[3000-3005 4000-4005]
# environment = %W[DROPBOX_ACCESS_TOKEN PROWL_API_KEY]
# volumes = %W[/var/run/docker.sock ~/.ssh ~/#{name}]

# ports.each do |port|
#   args << "-p #{port}:#{port}"
# end

# environment.each do |var_name|
#   var_content = ENV.fetch(var_name)
#   abort "#{var_name} cannot be empty" if var_content.empty?
#   args << "-e #{var_name}=#{var_content}"
# end

# volumes.each do |path|
#   args << "-v #{path}:#{File.expand_path(path)}"
# end

# puts "docker create -it #{args.join(' ')} --name #{name} --hostname #{name} botanicus/dev"
# puts "docker start #{name}"

# begin
#   puts "\nAutomatically connect to this docker instance on login? (Enter/C-c) "
#   STDIN.readline
# rescue Interrupt
# end

# File.open(File.join(ENV['HOME'], '.bashrc'), 'a') do |file|
#   file.puts <<~EOF
#     echo "~ Connecting to the Docker instance in 1s ..."; sleep 1
#     docker attach #{name} || docker start #{name} && docker attach #{name}
#   EOF
# end
