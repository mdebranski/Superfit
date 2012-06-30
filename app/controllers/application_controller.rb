class ApplicationController < ActionController::Base
  protect_from_forgery

  def index

  end

  def mobile
    render layout: nil
  end

  def jqm
    @wods = Wod.all.sort_by(&:name)
    @categories = @wods.map(&:category).uniq.sort
    render layout: nil
  end

  def models
    wods = Wod.all.sort_by(&:name)
    categories = wods.map(&:category).uniq.sort.map {|c| {id: c, name: c}}

    render json: {wods: wods, categories: categories}
  end
end
