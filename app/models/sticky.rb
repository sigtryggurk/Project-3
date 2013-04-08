class Sticky < ActiveRecord::Base
  attr_accessible :text, :user_id

  def set_text(text)
    self.text=text
  end
end
