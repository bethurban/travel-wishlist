require './config/environment'
require 'date'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
    use Rack::Flash
  end

  get '/' do
    if Helpers.logged_in?(session)
      redirect '/destinations'
    else
      erb :index
    end
  end

  get '/signup' do
    if Helpers.logged_in?(session)
      redirect '/destinations'
    else
      erb :'/users/new'
    end
  end

  post '/signup' do
    @user = User.new(username: params["username"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
    if @user.save
      redirect '/destinations'
    else
      flash[:message]= "You must include a username, email address, and password when signing up."
      redirect '/signup'
    end
  end

  get '/login' do
    if Helpers.logged_in?(session)
      redirect '/destinations'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user && @user.authenticate(params["password"])
      session[:user_id] = @user.id
      redirect "/destinations"
    else
      flash[:message]= "Your username and/or password is incorrect. Please try again."
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

end
