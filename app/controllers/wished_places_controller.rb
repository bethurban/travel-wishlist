class WishedPlacesController < ApplicationController
  get '/destinations/wish/new' do
    if Helpers.logged_in?(session)
      erb :'wishedplaces/new'
    else
      flash[:message]= "Please log in."
      redirect '/'
    end
  end

  post '/destinations/wish' do
    if VisitedPlace.find_by_destination(params["destination"])
      VisitedPlace.find_by_destination(params["destination"]).delete
    end
    @user = Helpers.current_user(session)
    @destination = WishedPlace.new(destination: params["destination"], travel_partner: params["travel_partner"], notes: params["notes"])
    @destination.user_id = @user.id
    if @destination.save
      redirect "/destinations/wish/#{@destination.id}"
    else
      flash[:message]= "You must include a destination name. Please try again."
      redirect '/destinations'
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
    @user = Helpers.current_user(session)
    @destination = WishedPlace.find_by_id(params[:id])
    if Helpers.logged_in?(session) && @user.id == @destination.user_id
      if @destination.update(destination: params["destination"], travel_partner: params["travel_partner"], notes: params["notes"])
        redirect "/destinations/wish/#{@destination.id}"
      else
        flash[:message]= "You must enter a destination name. Please try again."
        redirect "/destinations/wish/#{@destination.id}/edit"
      end
    else
      flash[:message]= "Please log in."
      redirect '/'
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
