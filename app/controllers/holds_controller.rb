class HoldsController < ApplicationController
  def index
    url ="users/#{params[:id]}/requests"
    requests = Requests.new(uniqname: params[:id])
    render json: requests.list
  end
end
