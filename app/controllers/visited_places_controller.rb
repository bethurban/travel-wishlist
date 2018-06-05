class VisitedPlacesController < ApplicationController
  get '/destinations/new' do
    if Helpers.logged_in?(session)
      erb :'/visitedplaces/new'
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

  patch '/destinations/:id' do
    @user = Helpers.current_user(session)
    @destination = VisitedPlace.find_by_id(params[:id])
    if Helpers.logged_in?(session) && @user.id == @destination.user_id
      if @destination.update(destination: params["destination"], date_traveled: params["date_traveled"], travel_partner: params["travel_partner"], notes: params["notes"])
        redirect "/destinations/#{@destination.id}"
      else
        flash[:message]= "You must enter a destination name and date traveled. Please try again."
        redirect "destinations/#{@destination.id}/edit"
      end
    else
      flash[:message]= "Please log in."
      redirect '/'
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

end
