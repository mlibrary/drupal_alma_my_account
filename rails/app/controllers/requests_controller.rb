class RequestsController < ApplicationController
  def index
    requests = Requests.new(uniqname: params[:id])
    render json: requests.list
  end
  def delete
    RequestCanceler.new().cancel(uniqname: params[:id], request_id: params[:request_id]) 
  end
end
