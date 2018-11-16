require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @files = Dir.glob('public/*').map {|file| File.basename(file) }.sort
  erb :home
end

get '/?sort=rev' do
  @files = Dir.glob('public/*').map {|file| File.basename(file) }.sort.reverse
  erb :home
end

not_found do
  "Oopsie, YOU made a poopsie."
end