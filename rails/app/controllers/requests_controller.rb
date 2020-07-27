class RequestsController < ApplicationController
  def index
    requests = Requests.new(uniqname: params[:id])
    resp = requests.list
    render json: resp.body, status: resp.status
  end
  def delete
    RequestCanceler.new().cancel(uniqname: params[:id], request_id: params[:request_id]) 
  end
end
