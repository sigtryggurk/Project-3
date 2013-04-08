class HomeController < ApplicationController
  def index
    @stickies=session[:stickies]
    session[:stickies]=nil
  end
end
