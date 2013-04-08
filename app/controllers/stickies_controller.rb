class StickiesController < ApplicationController
  def create
    Sticky.delete_all(:user_id=>current_user.id)
    text=params[:text].split(',')
    text.each{|content|
      Sticky.create(:text=>content,:user_id=>current_user.id)
    }
    redirect_to root_url
  end
end
