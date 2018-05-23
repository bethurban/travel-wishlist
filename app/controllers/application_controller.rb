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
      erb :'/destinations/destinations'
    else
      redirect '/'
    end
  end

  post '/destinations' do
    WishedPlace.find_by_destination(params["visited_place"]).delete
    @visit = VisitedPlace.new(destination: params["visited_place"])
    @visit.user_id = session[:user_id]
    @visit.save
    if @visit.save
      redirect '/destinations/edit'
    else
      redirect '/destinations'
    end
  end

  get '/destinations/edit' do
    @destination = VisitedPlace.all.last
    erb :'/destinations/edit'
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
    erb :'/destinations/show'
    #Fill out show.erb. Need to add folder to views to separate out visited and wished routes?
  end

end
