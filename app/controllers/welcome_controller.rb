class WelcomeController < ApplicationController
  def index
    flash[:notice] = "你好，晚安！"
  end
end
