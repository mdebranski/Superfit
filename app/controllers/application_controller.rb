class ApplicationController < ActionController::Base
  #protect_from_forgery

  def superfit
    session[:abc] = 123
    @wods = Wod.all.sort_by(&:name)
    @categories = @wods.map(&:category).uniq.sort
    Rails.logger.debug "SESSION: #{request.session_options[:id].inspect}"
    Rails.logger.debug "USER1: #{current_user}"
    render layout: nil
  end

  def models
    session[:abc] = 456
    wods = Wod.all.sort_by(&:name)
    categories = wods.map(&:category).uniq.sort.map {|c| {id: c, name: c}}
    Rails.logger.debug "SESSION2: #{request.session_options[:id].inspect}"
    Rails.logger.debug "USER: #{current_user}"
    render json: {user: current_user, wods: wods, categories: categories}
  end
end
