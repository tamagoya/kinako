class BooksController < ApplicationController
  def new
  end

  def create
    Kindle::Mail2MyKindle.send(current_user.email, params[:target_url])
    @result = "Send " +  params[:target_url] + " to " + current_user.email
  end
end
