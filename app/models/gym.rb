class Gym < ActiveRecord::Base

  attr_accessible :id, :name, :website, :address, :city, :state, :phone

  before_create do
    self.lower_name = name.downcase
  end

  def as_json(options={})
    super(only: [:id, :name, :website, :address, :city, :state, :phone])
  end

end
