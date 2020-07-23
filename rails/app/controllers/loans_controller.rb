class LoansController < ApplicationController
  def index
    loans = Loans.new(uniqname: params[:id])
    render json: loans.list
  end
  def renew
    response = LoanRenewer.new().renew(uniqname: params[:id], barcode: params[:barcode])
    render json: response
  end
end
