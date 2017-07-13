class Activity < ActiveRecord::Base
  belongs_to :user
  validates :user, uniqueness: false, allow_nil: true


end