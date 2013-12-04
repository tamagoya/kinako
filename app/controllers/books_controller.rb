class BooksController < ApplicationController
  def new
  end

  def create
    @result = params[:target_url]
  end
end
