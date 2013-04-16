require 'test_helper'
#
#Testing Strategy:
#Test every type asynchronous call that the application makes:
#New-sticky => cookies should contain 'id=>""'
#Update-sticky => cookies should have 'id=>newText'
#Delete-sticky => 'id' should be removed from cookies
#
class StickiesControllerTest < ActionController::TestCase
  new='{text:"",position:{top:200,left:50},textProperties:{"font-weight":400,"font-style":"normal","text-decoration":"none"}'

  test "should add empty to cookies" do
    id="new123"
    post :create_sticky,{:id=>id,:attr=>new}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal new,stickies[id]
  end

  test "should update text in cookie" do
    id="new123"
    post :create_sticky,{:id=>id,:attr=>new}
    update='{text:"HELLO WORLD",position:{top:200,left:50},textProperties:{"font-weight":400,"font-style":"normal","text-deco
ration":"none"}'
    post :update_sticky,{:id=>id,:attr=>update}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal update,stickies[id]
  end

  test "should update position in cookie" do
    id="new123"
    post :create_sticky,{:id=>id,:attr=>new}
    update='{text:"",position:{top:500,left:-10},textProperties:{"font-weight":400,"font-style":"normal","text-deco
ration":"none"}'
    post :update_sticky,{:id=>id,:attr=>update}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal update,stickies[id]
  end

  test "should update textProperties in cookie" do
    id="new123"
    post :create_sticky,{:id=>id,:attr=>new}    
    update='{text:"",position:{top:200,left:50},textProperties:{"font-weight":700,"font-style":"italic","text-decoration":"underline"}'
    post :update_sticky,{:id=>id,:attr=>update}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal update,stickies[id]
  end

  test "should remove sticky from cookies" do
    id="new123"
    post :create_sticky,{:id=>id}
    post :delete_sticky,{:id=>id}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal nil,stickies[id]

  end
end
