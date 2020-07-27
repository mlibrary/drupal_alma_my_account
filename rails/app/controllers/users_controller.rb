class UsersController < ApplicationController
  def index
    patron = Patron.new(uniqname: params[:id])
    resp = patron.list
    render json: resp.body, status: resp.status
  end
end
