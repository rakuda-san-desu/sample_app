require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url #static_pages/homeにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
  end

  test "should get help" do
    get static_pages_help_url  #static_pages/helpにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
  end

  test "should get about" do
    get static_pages_about_url  #static_pages/aboutにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
  end

end
