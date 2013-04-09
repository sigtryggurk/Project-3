class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_url
    end
  end
  
  """
  Start a new session:
  Requires: Only one session per browser
  """
  def create
    user = User.authenticate(params[:email], params[:password])
    if user and not current_user
      session[:user_id] = user.id
      cookies[:stickies]=Sticky.merge_temporary_with_stored(cookies[:stickies],user.id) #retrieves stored stickies and merges with the current temporary ones

      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  """
  Terminates session:
  Saves changes to server
  Empties cookie and session variables 
  """
  def destroy
    stickies = Marshal::load(cookies[:stickies])
    Sticky.update_or_create_stickies(stickies,session[:user_id]) #runs through all stickies in cookie and updates existing ones and creates new ones
    session[:user_id] = nil
    cookies[:stickies]=Marshal::dump({})
    redirect_to root_url, :notice => "Logged out!"
  end
end


