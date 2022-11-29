require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    status 404
    return "Sorry! We couldn't find this post."
  end

  get '/' do
    name = params[:name]
    name = "Stranger" if name.nil?
    return "Hello, #{name}!"
  end

  post '/' do
    name = params[:name]
    return "Posted '#{name}'"
  end

  post "/submit" do
    name = params[:name]
    message = params[:message]

    return "Thanks #{name}, you sent this message: '#{message}'"
  end

  get '/names' do
    return "Julia, Mary, Karim"
  end

  post '/sort-names' do
    names = params[:names].split(',')
    return names.sort.join(',')
  end

  get "/hello" do
    return erb(:index)
  end
end