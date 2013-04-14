class ApplicationController < ActionController::Base
  #protect_from_forgery

  def superfit
    @wods = Wod.all.sort_by(&:name)
    @categories = @wods.map(&:category).uniq.sort
    render layout: nil
  end

  def models
    wods = Wod.all.sort_by(&:name)
    categories = wods.map(&:category).uniq.sort.map {|c| {id: c, name: c}}
    render json: {user: current_user, wods: wods, categories: categories}
  end
end
