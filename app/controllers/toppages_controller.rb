class ToppagesController < ApplicationController
  def index
    if logged_in?
      @micropost = current_user.microposts.build #form_witho用
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page]) #一覧表示用
      #お気に入り機能
      @favorite = current_user.favorites.build #form_witho用
      @favorites = current_user.favorites.order(id: :desc).page(params[:page]) #一覧表示用
  
    end
  end
end
