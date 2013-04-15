class StickiesController < ApplicationController
  """
  Creates an empty sticky in cookies
  """
  def create_sticky
    if cookies[:stickies]!=nil
      stickies=Marshal::load(cookies[:stickies])
    else
      stickies={}
    end
    stickies[params[:id]]=params[:attr]
    cookies[:stickies]=Marshal::dump(stickies)
    redirect_to root_url
  end
  
  """
  Looks for sticky with given id and updates it
  """
  def update_sticky
    stickies=Marshal::load(cookies[:stickies])
    stickies[params[:id]]=params[:attr]
    cookies[:stickies]=Marshal::dump(stickies)
    redirect_to root_url
  end
  """
  Removes the sticky from cookies with the specified id and
  if user is logged in and authorized it removes it from the server as well
  """
  def delete_sticky
    stickies=Marshal::load(cookies[:stickies])
    stickies.delete(params[:id])
    cookies[:stickies]=Marshal::dump(stickies)
    if !params[:id].start_with?("new") and current_user
      sticky=Sticky.find(params[:id])
      if sticky!=nil and sticky.user_id==current_user.id
        Sticky.destroy(params[:id])
      end
    end
    redirect_to root_url
  end
end
