class LoansController < ApplicationController
  def index
    loans = Loans.new(uniqname: params[:id])
    render json: loans.list
  end
  def renew
    LoanRenewer.new().renew(uniqname: params[:id], barcode: params[:barcode])
  end
end
