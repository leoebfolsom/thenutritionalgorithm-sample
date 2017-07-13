class ListBuy < ActiveRecord::Base
  belongs_to :user
  belongs_to :list
  has_many :images
  validates :user_id, presence: true
  validates :list_id, presence: true
  validates :total_price, numericality: true
  validates :total_calories, numericality: true
  validates :total_carbohydrates, numericality: true
  validates :total_fat, numericality: true
  validates :total_protein, numericality: true
  validates :total_sugar, numericality: true
  validates :total_vitamin_a, numericality: true
  validates :total_vitamin_c, numericality: true
  validates :total_iron, numericality: true
  validates :total_calcium, numericality: true
  validates :total_sodium, numericality: true
  validates :total_fiber, numericality: true
end