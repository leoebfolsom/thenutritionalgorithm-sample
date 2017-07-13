class Quantity < ActiveRecord::Base
  belongs_to :food
  belongs_to :list

  validates :food_id, presence: true

  validates :amount, presence: true, :numericality => { :greater_than => -1 }


end
