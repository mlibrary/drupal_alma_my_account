class FinesController < ApplicationController
  def email
    fines = FinesEmail.new(uniqname: params[:id])
    render json: fines.list
  end
  def index
    fines = FinesPage.new(uniqname: params[:id])
    render json: fines.list
  end
  def pay
    FinePayer.new().pay(uniqname: params[:id], reference: params[:reference], amount: params[:amount])  
  end
end
