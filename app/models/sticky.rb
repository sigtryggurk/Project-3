class Sticky < ActiveRecord::Base
  attr_accessible :text, :user_id
  
  """
  Class method that takes in a hash (id=>text)  and merges it with a hash of all stickies belonging
  to a user specifed by 'user_id'
  
  Requires that the hash is passed as a Marshal serialized object
  Returns the mergure of the two hashes as a Marshal serialized object
  """
  def self.merge_temporary_with_stored(temporary,user_id)
    temporary=Marshal::load(temporary)
    stored={}
    Sticky.find_all_by_user_id(user_id).map{|sticky| stored[sticky.id.to_s]=sticky.text}
    temporary=temporary.merge(stored)
    return Marshal::dump(temporary)
  end

  """
  Factory class method that accepts a hash of stickies (id=>text) and updates
  pre-existing stickies and adds the new ones to the database for a user specified
  by user_id
  Modifies/Creates tuples in stickies table
  Returns nothing
  """
  def self.update_or_create_stickies(stickies,user_id)
    stickies.each_pair do |id,text|
      if id.start_with?("new")
        Sticky.create(:user_id=>user_id,:text=>text)
      else
        sticky=Sticky.find_or_create_by_id(:id=>id)
        sticky.text=text
        sticky.save
      end

    end
  end

end