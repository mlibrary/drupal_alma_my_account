class FinesController < ApplicationController
  def email
    fines = FinesEmail.new(uniqname: params[:id])
    render json: fines.list
  end
  def index
    fines = FinesPage.new(uniqname: params[:id])
    render json: fines.list
  end
end
