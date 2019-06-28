require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup  #各テストが実行される直前で実行される
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end


  test "should get help" do
    get help_path  #static_pages/helpにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
    assert_select "title", "Help | #{@base_title}"  #以下のHTMLが存在するはず
  end

  test "should get about" do
    get about_path  #static_pages/aboutにアクセスしたら
    assert_response :success  #レスポンスが成功するはず
    assert_select "title", "About | #{@base_title}"  #以下のHTMLが存在するはず
  end
  
  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
