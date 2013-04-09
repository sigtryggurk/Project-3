class HomeController < ApplicationController
  """
  Renders main index.
  Grabs stickies on cookie
  """
  def index
    if cookies[:stickies]!=nil
      @stickies=Marshal::load(cookies[:stickies])
    else
      @stickies={}
    end
  end
end
