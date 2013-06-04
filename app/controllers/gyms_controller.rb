class GymsController < ApplicationController
  respond_to :json

  def index
    gyms =
      if params[:name]
        Gym.where("lower_name like ?", "%#{params[:name].downcase}%")
      else
        Gym.all()
      end
    render json: gyms.limit(100)
  end

end
