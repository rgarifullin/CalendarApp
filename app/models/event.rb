class Event < ActiveRecord::Base
  include IceCube

  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :schedule, presence: true

  serialize :schedule, IceCube::Schedule
end
