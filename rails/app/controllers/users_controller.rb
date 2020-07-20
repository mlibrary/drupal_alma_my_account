class UsersController < ApplicationController
  def index
    patron = Patron.new(uniqname: params[:id])
    render json: patron.list
  end
end
