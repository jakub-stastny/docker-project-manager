Signal::INT.trap { exit }

unless ARGV.size > 0
  abort "Usage: #{PROGRAM_NAME} my-project"
end

puts "~ Welcome to the Docker project manager!"
name = ARGV[0]
args = Array(String).new
env_var_keys = ARGV[1..-1]
volumes = ["/var/run/docker.sock", "~/.ssh", "~/#{name}"]

if env_var_keys.empty?
  puts "~ No environment variables are going to be exposed."
end

env_var_keys.each do |var_name|
  print "#{var_name}: "
  var_content = (STDIN.gets || "").chomp
  abort "#{var_name} cannot be empty." if var_content.empty?
  args << "-e #{var_name}=#{var_content}"
end

volumes.each do |path|
  args << "-v #{path}:#{File.expand_path(path)}"
end

print "What ports do you want to expose? (I. e. 3000-3005 4000): "
(STDIN.gets || "").split(" ") do |port|
  next if port.empty?
  args << "-p #{port.match(/:/) ? port : "#{port}:#{port}"}"
end

puts "docker create -it #{args.join(' ')} --name #{name} --hostname #{name} botanicus/dev"
puts "docker start #{name}"
puts "docker attach #{name}"

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
