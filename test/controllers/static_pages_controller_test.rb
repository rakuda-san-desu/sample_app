require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup  #各テストが実行される直前で実行される
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get home" do
    get static_pages_home_url #static_pages/homeにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
    assert_select "title", "Home | #{@base_title}"  #以下のHTMLが存在するはず
  end

  test "should get help" do
    get static_pages_help_url  #static_pages/helpにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
    assert_select "title", "Help | #{@base_title}"  #以下のHTMLが存在するはず
  end

  test "should get about" do
    get static_pages_about_url  #static_pages/aboutにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
    assert_select "title", "About | #{@base_title}"  #以下のHTMLが存在するはず
  end

end
