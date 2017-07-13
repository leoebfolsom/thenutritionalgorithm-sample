class Food < ActiveRecord::Base
  searchkick# synonyms: [["scallion", "green onion"]]

  belongs_to :user
  
  has_many :quantities, :dependent => :destroy
  has_many :lists, :through => :quantities, :dependent => :delete_all#This is suspect, why is this line necessary?
  
  before_save { self.name = name.downcase } #does "self" make sense in this context or should this only be for users? railstutorial.org end of section 6.2
  validates :name, presence: true, length: { maximum: 150 }, uniqueness: { case_sensitive: false }
  validates :calories, presence: true
  validates :carbohydrates, presence: true
  validates :fat, presence: true
  validates :protein, presence: true
  validates :sugar, presence: true
  validates :fiber, presence: true
  validates :calcium, presence: true
  validates :vitamin_a, presence: true
  validates :vitamin_c, presence: true
  validates :iron, presence: true
  validates :sodium, presence: true
  validates :price, presence: true
  validates :aisle, presence: true

end