class TransactionsController < ApplicationController
  def index
    url ="users/#{params[:id]}/loans"
    loans = Loans.new(uniqname: params[:id])
    render json: loans.list
  end
end
