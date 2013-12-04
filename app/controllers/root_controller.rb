class RootController < ApplicationController
  def index
    redirect_to new_book_path
  end
end
