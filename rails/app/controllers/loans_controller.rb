class LoansController < ApplicationController
  def index
    loans = Loans.new(uniqname: params[:id])
    resp = loans.list
    render json: resp.body, status: resp.status
  end
  def renew
    response = LoanRenewer.new(uniqname: params[:id]).renew(barcode: params[:barcode])
    render json: response
  end
end
