require 'test_helper'
#
#Testing Strategy:
#Test every type asynchronous call that the application makes:
#New-sticky => cookies should contain 'id=>""'
#Update-sticky => cookies should have 'id=>newText'
#Delete-sticky => 'id' should be removed from cookies
#
class StickiesControllerTest < ActionController::TestCase

  test "should add empty to cookies" do
    id="new123"
    post :create_sticky,{:id=>id}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal "",stickies[id]
  end

  test "should update text in cookie" do
    id="new123"
    text="Hello Word"
    post :create_sticky,{:id=>id}
    post :update_sticky,{:id=>id,:text=>text}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal text,stickies[id]
  end

  test "should remove sticky from cookies" do
    id="new123"
    post :create_sticky,{:id=>id}
    post :delete_sticky,{:id=>id}
    stickies=Marshal::load(cookies[:stickies])
    assert_equal nil,stickies[id]

  end
end
