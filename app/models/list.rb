class List < ActiveRecord::Base
#  mount_uploader :image, ImageUploader

  belongs_to :user
  default_scope -> { order(updated_at: :desc) }
  has_many :quantities
  has_many :posts, dependent: :destroy
  has_many :list_buys, dependent: :destroy
  
  has_many :foods, :through => :quantities, :dependent => :delete_all
  
  
  before_save { self.name = name.downcase }
  
  validates :user_id, presence: true
  validates :days, presence: true
  validates :name, presence: true, length: { maximum: 140 }#,
  validates :note, length: { maximum: 140 }
                    
  validates :age, presence: true
  validates :gender, presence: true
  validates :store, presence: true
  validates :max_price, presence: true

  def total_calories
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.calories}.sum# + self.groupits.map{|q| q.amount * q.group.total_calories}.sum
  end
  
  def total_carbohydrates
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.carbohydrates}.sum# + self.groupits.map{|q| q.amount * q.group.total_carbohydrates}.sum
  end
  
  def total_fat
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.fat}.sum# + self.groupits.map{|q| q.amount * q.group.total_fat}.sum
  end
  
  def total_protein
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.protein}.sum# + self.groupits.map{|q| q.amount * q.group.total_protein}.sum
  end
  
  def total_sugar
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.sugar}.sum# + self.groupits.map{|q| q.amount * q.group.total_sugar}.sum
  end

 # def total_potassium
 #   self.quantities.map{|q| q.amount * q.food.potassium}.sum# + self.groupits.map{|q| q.amount * q.group.total_potassium}.sum
 # end
  
  def total_fiber
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.fiber}.sum# + self.groupits.map{|q| q.amount * q.group.total_fiber}.sum
  end

  def total_vitamin_a
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.vitamin_a}.sum# + self.groupits.map{|q| q.amount * q.group.total_vitamin_a}.sum
  end
  
  def total_vitamin_c
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.vitamin_c}.sum# + self.groupits.map{|q| q.amount * q.group.total_vitamin_c}.sum
  end
  
  def total_calcium
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.calcium}.sum# + self.groupits.map{|q| q.amount * q.group.total_calcium}.sum
  end
  
  def total_iron
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.iron}.sum #+ self.groupits.map{|q| q.amount * q.group.total_iron}.sum
  end
  
  def total_sodium
    self.quantities.map{|q| q.amount * (0.01*q.percentage) * q.food.sodium}.sum# + self.groupits.map{|q| q.amount * q.group.total_sodium}.sum
  end
  
  def total_price
    t = 0
    self.quantities.each do |q|
      if q.pantry == 0
        t += q.amount * q.food.price
      end
    end
    t.to_f
  end

  def List.search_note(query)
    search_length = query.split.length
    where([(['note LIKE ?'] * search_length).join(' AND ')] + query.split.map { |q| "%#{q}%" })
  end
  def List.search_name(query)
    search_length = query.split.length
    where([(['name LIKE ?'] * search_length).join(' AND ')] + query.split.map { |q| "%#{q}%" })
  end
  def Post.search_body(query)
    search_length = query.split.length
    where([(['body LIKE ?'] * search_length).join(' AND ')] + query.split.map { |q| "%#{q}%" })
  end
  def Post.search_title(query)
    search_length = query.split.length
    where([(['title LIKE ?'] * search_length).join(' AND ')] + query.split.map { |q| "%#{q}%" })
  end
  def Food.home_search(query)
    search_length = query.split.length
    where([(['name LIKE ?'] * search_length).join(' AND ')] + query.split.map { |q| "%#{q}%" })
  end


  def working?
    job_id == 1
  end
  
  def nutrition_constraints_calories
    if self.nutrition_constraints["min_calories"].to_f >= self.nutrition_constraints["max_calories"].to_f  - 50
      self.errors.add(:nutrition_constraints, "error: Minimum calories must be at least 50 calories below maximum calories.")
    end
  end
  def nutrition_constraints_min_calories
    if self.nutrition_constraints["min_calories"] == ""
      self.errors.add(:nutrition_constraints, "error (min calories): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_max_calories
    if self.nutrition_constraints["max_calories"] == ""
      self.errors.add(:nutrition_constraints, "error (max calories): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_carbohydrates

    if self.nutrition_constraints["carbohydrates"].length > 0 && self.nutrition_constraints["carbohydrates"].to_f == 0
      self.errors.add(:nutrition_constraints, "error (carbohydrates): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_fat

    if self.nutrition_constraints["fat"].length > 0 &&  self.nutrition_constraints["fat"].to_f == 0
      self.errors.add(:nutrition_constraints, "error (fat): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_protein

    if self.nutrition_constraints["protein"].length > 0 && self.nutrition_constraints["protein"].to_f == 0
      self.errors.add(:nutrition_constraints, "error (protein): Please enter a numerical value for all nutrition constraints.")
    end

  end
  def nutrition_constraints_min_fiber

    if self.nutrition_constraints["min_fiber"] == ""
      self.errors.add(:nutrition_constraints, "error (min fiber): Please enter a numerical value for all nutrition constraints.")
    end

  end
  def nutrition_constraints_min_vitamin_a

    if self.nutrition_constraints["min_vitamin_a"] == ""
      self.errors.add(:nutrition_constraints, "error (min vitamin a): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_min_vitamin_c

    if self.nutrition_constraints["min_vitamin_c"] == ""
      self.errors.add(:nutrition_constraints, "error (min vitamin c): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_min_calcium

    if self.nutrition_constraints["min_calcium"] == ""
      self.errors.add(:nutrition_constraints, "error (min calcium): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_min_iron
    if self.nutrition_constraints["min_iron"] == ""
      self.errors.add(:nutrition_constraints, "error (min iron): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_max_sodium

    if self.nutrition_constraints["max_sodium"] == ""
      self.errors.add(:nutrition_constraints, "error (max sodium): Please enter a numerical value for all nutrition constraints.")
    end
  end
  def nutrition_constraints_max_sugar

    if self.nutrition_constraints["max_sugar"] == ""
      self.errors.add(:nutrition_constraints, "error (max sugar): Please enter a numerical value for all nutrition constraints.")
    end
  end

  def nutrition_constraints_height

    if self.nutrition_constraints["height"] == "" || self.nutrition_constraints["height"].to_i == 0
      self.errors.add(:nutrition_constraints, "error (height): Please enter your height in inches. You can also go to your profile settings to set your default height.")
    end
  end

  def nutrition_constraints_weight

    if self.nutrition_constraints["weight"] == "" || self.nutrition_constraints["weight"].to_i == 0
      self.errors.add(:nutrition_constraints, "error (weight): Please enter your weight in pounds. You can also go to your profile settings to set your default weight.")
    end
  end


end
