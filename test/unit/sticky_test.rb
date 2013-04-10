require 'test_helper'
#
#Testing Strategy:
#For merge_temporary_and_stored:
# 	1. Basic test
#	2. Temporary stickies empty
#	3. Stored stickies empty
#	4. Both empty
#
#For update_or_create_stickies:
#	1.Only updates
#	2.Only new stickies
#	3.Basic with both
#	4.Empty update

class StickyTest < ActiveSupport::TestCase
  test "merge temp and stored" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    temporary=Marshal::dump({"new23"=>"ihtfp","new42"=>"jon"})
    expected={sticky1.id.to_s=>sticky1.text,sticky2.id.to_s=>sticky2.text,"new23"=>"ihtfp","new42"=>"jon"}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,1))
    assert_equal expected,got
  end 
  
  test "merge empty temp and stored" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    temporary=Marshal::dump({})
    expected={sticky1.id.to_s=>sticky1.text,sticky2.id.to_s=>sticky2.text}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,1))
    assert_equal expected,got
  end
  
  test "merge temp and empty stored" do
    expected={"new23"=>"ihtfp","new42"=>"jon"}
    temporary=Marshal::dump(expected)
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,2))
    assert_equal expected,got

  end
  test "empty merge" do 
    temporary=Marshal::dump({})
    expected={}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,2))
    assert_equal expected,got

  end
  test "only updates" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    assert_equal "hello",sticky1.text
    assert_equal "world",sticky2.text
   
    text1="you are the weakest link!"
    text2="goodbye"
    
    stickies={sticky1.id.to_s=>text1,sticky2.id.to_s=>text2}
   
    Sticky.update_or_create_stickies(stickies,1)
   
    sticky1=Sticky.find(sticky1.id)
    sticky2=Sticky.find(sticky2.id)
    assert_equal text1,sticky1.text
    assert_equal text2,sticky2.text
  end

  test "only create" do
    stickies={"new23"=>"ihtfp","new42"=>"jon"}
    Sticky.update_or_create_stickies(stickies,2)
    
    newstickies=Sticky.find_all_by_user_id(2)
    
    assert_equal newstickies.length,2 
    sticky1=newstickies[0]
    sticky2=newstickies[1]
    assert ((sticky1.text=="ihtfp" and sticky2.text="jon") or (sticky1.text=="jon" and sticky2.text="ihtfp"))
     
  end

  test "update and create" do
    require 'set'
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    
    text1="you are the weakest link!"
    text2="goodbye"
    text3="ihtfp"
    text4="jon"

    expected=Set.new
    expected.merge([text1,text2,text3,text4])

    stickies={sticky1.id.to_s=>text1,sticky2.id.to_s=>text2,"new23"=>text3,"new42"=>text4}
    
    Sticky.update_or_create_stickies(stickies,1)

    newstickies=Sticky.all.map{|sticky| sticky.text}
    got=Set.new
    got.merge(newstickies)

    assert_equal 4, newstickies.length

    assert_equal expected,got    

  end
  
  test "empty update and empty create" do
    stickies={}
    Sticky.update_or_create_stickies(stickies,2)
    newstickies=Sticky.find_all_by_user_id(2)
    assert_equal 0, newstickies.length
  end

end
