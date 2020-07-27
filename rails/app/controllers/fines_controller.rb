class FinesController < ApplicationController
  def email
    fines = FinesEmail.new(uniqname: params[:id])
    resp = fines.list
    render json: resp.body, status: resp.status
  end
  def index
    fines = FinesPage.new(uniqname: params[:id])
    resp = fines.list
    render json: resp.body, status: resp.status
  end
  def pay
    FinePayer.new().pay(uniqname: params[:id], reference: params[:reference], amount: params[:amount])  
  end
end
