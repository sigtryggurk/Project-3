class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user,:cookies

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_404(exception=nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end
    
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end
end
