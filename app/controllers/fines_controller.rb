class FinesController < ApplicationController
  def index
    url ="users/#{params[:id]}/fines"
    fines = Fines.new(uniqname: params[:id])
    render json: fines.list
  end
end
