require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
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
      @wished_places = WishedPlace.all
      @visited_places = VisitedPlace.all
      erb :'/users/destinations'
    else
      redirect '/'
    end
  end

  post '/destinations/update' do
    WishedPlace.find_by_destination(params["visited_place"]).delete
    @destination = VisitedPlace.new(destination: params["visited_place"])
    @destination.user_id = session[:user_id]
    @destination.save
    if @destination.save
      redirect "/destinations/#{@destination.id}/edit"
    else
      redirect '/destinations'
    end
  end

  get '/destinations/create' do
    erb :'/visitedplaces/create'
  end

  get '/destinations/:id/edit' do
    @destination = VisitedPlace.find_by_id(params[:id])
    erb :'/visitedplaces/edit'
  end

  post '/destinations' do
    @user = Helpers.current_user(session)
    @destination = VisitedPlace.new(destination: params["destination"])
    @destination.user_id = @user.id
    @destination.save
    if @destination.save
      @destination.date_traveled = params["date_traveled"]
      @destination.travel_partner = params["travel_partner"]
      @destination.notes = params["notes"]
      @destination.save
      redirect "/destinations/#{@destination.id}"
    else
      redirect '/destinations'
    end
  end

  patch '/destinations/:id' do
    @destination = VisitedPlace.find_by_id(params[:id])
    @destination.date_traveled = params["date_traveled"]
    @destination.travel_partner = params["travel_partner"]
    @destination.notes = params["notes"]
    @destination.save
    redirect "/destinations/#{@destination.id}"
  end

  get '/destinations/:id' do
    @destination = VisitedPlace.find_by_id(params[:id])
    erb :'/visitedplaces/show'
  end

  get '/destinations/wish/:id' do
    @destination = WishedPlace.find_by_id(params[:id])
    erb :'/wishedplaces/show'
  end

end
