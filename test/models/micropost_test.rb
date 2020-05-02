require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # @micropostに以下を代入
    # @userに紐づいたMicropostオブジェクトを返す（content属性に"Lorem ipsum"の値を持つ）
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    # trueである→　@micropostは有効か
    assert @micropost.valid?
  end

  test "user id should be present" do
    # @micropostのuser_idにnilを代入
    @micropost.user_id = nil
    # falseである→　@micropostは有効か
    assert_not @micropost.valid?
  end
  
  test "content should be present" do
    # @micropost.contentに"   "を追加
    @micropost.content = "   "
    # falseである→　@micropostは有効か
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    # @micropost.contentにa×141（141文字）を追加
    @micropost.content = "a" * 141
    # falseである→　@micropostは有効か
    assert_not @micropost.valid?
  end
end