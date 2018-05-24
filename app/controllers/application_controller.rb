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
      erb :'/users/create_user'
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

  get '/destinations' do
    if Helpers.logged_in?(session)
      @user = Helpers.current_user(session)
      @wished_places = WishedPlace.all.find_all { |place| place.user_id == @user.id }
      @visited_places = VisitedPlace.all.find_all { |place| place.user_id == @user.id }
      erb :'/users/destinations'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  post '/destinations/update' do
    WishedPlace.find_by_destination(params["visited_place"]).delete
    @destination = VisitedPlace.new(destination: params["visited_place"])
    @destination.user_id = session[:user_id]
    @destination.date_traveled = "placeholder"
    @destination.save

    if @destination.save
      flash[:message]= "Awesome - you checked off a dream destination!"
      redirect "/destinations/#{@destination.id}/edit"
    else
      redirect '/destinations'
    end
  end

  get '/destinations/create' do
    if Helpers.logged_in?(session)
      erb :'/visitedplaces/create'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  get '/destinations/wish/create' do
    if Helpers.logged_in?(session)
      erb :'wishedplaces/create'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  get '/destinations/:id/edit' do
    @user = Helpers.current_user(session)
    @destination = VisitedPlace.find_by_id(params[:id])
    if Helpers.logged_in?(session) && @user.id == @destination.user_id
      erb :'/visitedplaces/edit'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  post '/destinations' do
    @user = Helpers.current_user(session)
    @destination = VisitedPlace.new(destination: params["destination"])
    @destination.user_id = @user.id
    @destination.date_traveled = params["date_traveled"]
    @destination.save
    if @destination.save
      @destination.travel_partner = params["travel_partner"]
      @destination.notes = params["notes"]
      @destination.save
      redirect "/destinations/#{@destination.id}"
    else
      flash[:message]= "You must include a destination name and date traveled. Please try again."
      redirect '/destinations'
    end
  end

  post '/destinations/wish' do
    if VisitedPlace.find_by_destination(params["destination"])
      VisitedPlace.find_by_destination(params["destination"]).delete
    end
    @user = Helpers.current_user(session)
    @destination = WishedPlace.new(destination: params["destination"])
    @destination.user_id = @user.id
    @destination.save
    if @destination.save
      @destination.travel_partner = params["travel_partner"]
      @destination.notes = params["notes"]
      @destination.save
      redirect "/destinations/wish/#{@destination.id}"
    else
      flash[:message]= "You must include a destination name. Please try again."
      redirect '/destinations'
    end
  end

  patch '/destinations/:id' do
    @destination = VisitedPlace.find_by_id(params[:id])
    @destination.destination = params["destination"]
    @destination.date_traveled = params["date_traveled"]
    @destination.save
    if @destination.save
      @destination.travel_partner = params["travel_partner"]
      @destination.notes = params["notes"]
      @destination.save
      redirect "/destinations/#{@destination.id}"
    else
      flash[:message]= "You must enter a destination name and date traveled. Please try again."
      redirect "destinations/#{@destination.id}/edit"
    end
  end

  get '/destinations/:id' do
    if Helpers.logged_in?(session)
      @destination = VisitedPlace.find_by_id(params[:id])
      erb :'/visitedplaces/show'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  get '/destinations/wish/:id' do
    if Helpers.logged_in?(session)
      @destination = WishedPlace.find_by_id(params[:id])
      erb :'/wishedplaces/show'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  get '/destinations/wish/:id/edit' do
    @destination = WishedPlace.find_by_id(params[:id])
    @user = Helpers.current_user(session)
    if Helpers.logged_in?(session) && @user.id == @destination.user_id
      erb :'/wishedplaces/edit'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  patch '/destinations/wish/:id' do
    @destination = WishedPlace.find_by_id(params[:id])
    @destination.destination = params["destination"]
    @destination.travel_partner = params["travel_partner"]
    @destination.notes = params["notes"]
    @destination.save
    redirect "/destinations/wish/#{@destination.id}"
  end

  delete '/destinations/:id/delete' do
    @user = Helpers.current_user(session)
    @destination = VisitedPlace.find_by_id(params[:id])
      if @user.id == @destination.user_id
        @destination.delete
        flash[:message]= "Destination deleted."
        redirect '/destinations'
      else
        redirect '/destinations'
      end
  end

  delete '/destinations/wish/:id/delete' do
    @user = Helpers.current_user(session)
    @destination = WishedPlace.find_by_id(params[:id])
      if @user.id == @destination.user_id
        @destination.delete
        flash[:message]= "Destination deleted."
        redirect '/destinations'
      else
        redirect '/destinations'
      end
  end

end
