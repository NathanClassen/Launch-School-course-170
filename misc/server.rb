require "socket"

def parse_request(request_line)
    http_method, path_and_params, http = request_line.split(" ")
    path, param = path_and_params.split("?")
    params = param.split("&").each_with_object({}) do |pair, hash|
      hash[pair.split("=")[0]] = pair.split("=")[1].to_i
    end

    [http_method, path, params]
  end

server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

    next unless request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<h1>Rolls!</h1>"

  params["rolls"].times { client.print "[#{rand(params["sides"]) + 1}]" }

  client.puts "</body>"
  client.puts "</html>"

  client.close
end
