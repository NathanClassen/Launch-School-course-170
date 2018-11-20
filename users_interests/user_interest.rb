require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'

before do
  @file = YAML.load_file("users.yaml")
end

helpers do

  def count_interests
    interests = 0
    @file.each do |user, info|
      num = info[:interests].size
      interests += num
    end
    interests
  end

end

get "/" do
  erb :home
end

get "/:user" do
  @user_name = params[:user]
  @user_info = @file[@user_name.to_sym]
  @other_users = @file.keys
  @other_users.delete(@user_name.to_sym)

  erb :layout, user: layout
end

