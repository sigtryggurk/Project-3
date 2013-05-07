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
    #helper method that takes a sticky and returns a JSON string represenatation of its attributes
    def repr(sticky)
      dict={:text=>sticky.text,:position=>YAML::load(sticky.position),:textProperties=>YAML::load(sticky.textProperties)}
    return dict.to_json.to_s
  end

  #have both stickies on the server and temporary stickies on cookies - checks to see if merge correctly
  test "merge temp and stored" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    sticky3={:text=>"ihtfp",:position=>{:top=>0,:left=>0},:textProperties=>{:'font-weight'=>"bold",:'font-style'=>"italic",:'text-decoration'=>"underline"}}
    temporary=Marshal::dump({"new23"=>sticky3.to_json.to_s})
    expected={sticky1.id.to_s=>repr(sticky1),sticky2.id.to_s=>repr(sticky2),"new23"=>sticky3.to_json.to_s}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,1))
    assert_equal expected,got
  end 

  #have only stickies on the server and none on the cookies - expect only the ones from the server
  test "merge empty temp and stored" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
    temporary=Marshal::dump({})
    expected={sticky1.id.to_s=>repr(sticky1),sticky2.id.to_s=>repr(sticky2)}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,1))
    assert_equal expected,got
  end 

  #have only stickies in cookies and none on the server - expect only the ones from cookies
  test "merge temp and empty stored" do
    sticky1={:text=>"ihtfp",:position=>{:top=>0,:left=>0},:textProperties=>{:'font-weight'=>"bold",:'font-style'=>"italic",:'text-decoration'=>"underline"}}.to_json.to_s
    expected={"new1"=>sticky1}
    temporary=Marshal::dump(expected)
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,2))
    assert_equal expected,got
  end
  
  #have no stickies on server and no in cookies - expect empty
  test "empty merge" do 
    temporary=Marshal::dump({})
    expected={}
    got=Marshal::load(Sticky.merge_temporary_with_stored(temporary,2))
    assert_equal expected,got
  end
  
  #only stickies on cookies  come from existing stickies (on the server) expect them to updated correctly
  test "only updates" do
    sticky1=stickies(:one)
    text="hello"
    position={:top=>0,:left=>0}.to_yaml
    textProperties={:'font-weight'=>400,:'font-style'=>"normal",:'text-decoration'=>"none"}.to_yaml
    assert_equal "hello",sticky1.text
    assert_equal position,sticky1.position
    assert_equal textProperties,sticky1.textProperties
   
    text1="you are the weakest link! goodbye"
    position1={"top"=>100,"left"=>100}
    textProperties1={"font-weight"=>700,'font-style'=>"italic",'text-decoration'=>"underline"}
    dict={:text=>text1,:position=>position1,:textProperties=>textProperties1}.to_json.to_s    
    stickies={sticky1.id.to_s=>dict}
   
    Sticky.update_or_create_stickies(stickies,1)
   
    sticky1=Sticky.find(sticky1.id)
    assert_equal text1,sticky1.text
    assert_equal position1,YAML::load(sticky1.position)
    assert_equal textProperties1,YAML::load(sticky1.textProperties)
  end

  #only new stickies on cookies - expect them to be created
  test "only create" do
    sticky1={:text=>"ihtfp",:position=>{:top=>0,:left=>0},:textProperties=>{:'font-weight'=>"bold",:'font-style'=>"italic",:'text-decoration'=>"underline"}}.to_json.to_s
    stickies={"new1"=>sticky1}
    Sticky.update_or_create_stickies(stickies,2)
    
    newsticky=Sticky.find_by_user_id(2)
    assert newsticky.text=="ihtfp"
     
  end

  #stickies on server and new stickies, expect all to be correct
  test "update and create" do
    sticky1=stickies(:one)
    sticky2=stickies(:two)
 
    text1="you are the weakest link! goodbye"
    position1={"top"=>100,"left"=>100}
    textProperties1={"font-weight"=>700,'font-style'=>"italic",'text-decoration'=>"underline"}
    dict={:text=>text1,:position=>position1,:textProperties=>textProperties1}.to_json.to_s

    sticky2={:text=>"ihtfp",:position=>{:top=>0,:left=>0},:textProperties=>{:'font-weight'=>"bold",:'font-style'=>"italic",:'text-decoration'=>"underline"}}.to_json.to_s
    
    stickies={sticky1.id.to_s=>dict,"new1"=>sticky2}
    
    Sticky.update_or_create_stickies(stickies,1)

    newstickies=Sticky.find_all_by_user_id(1)
    
    assert_equal 3,newstickies.length
    

  end

  #no sticky updates/creations - expect to find no stickies
  test "empty update and empty create" do
    stickies={}
    Sticky.update_or_create_stickies(stickies,2)
    newstickies=Sticky.find_all_by_user_id(2)
    assert_equal 0, newstickies.length
  end
end
