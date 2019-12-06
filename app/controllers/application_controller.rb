class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #Sessionヘルパーモジュールの読み込み
  include SessionsHelper
end
