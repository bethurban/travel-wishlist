class WishedToVisitedController < ApplicationController
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
end
