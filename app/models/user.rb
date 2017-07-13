class User < ActiveRecord::Base

  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauth_providers => [:facebook]
  before_save :ensure_authentication_token
  validates_uniqueness_of :name, case_sensitive: false

  has_many :lists, dependent: :destroy
  has_many :list_buys, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :comments, dependent: :destroy
  



  has_many :active_relationships, class_name:  "Relationship",
                                    foreign_key: "follower_id",
                                    dependent:   :destroy
  
  has_many :passive_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
                                    
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :foods, dependent: :destroy 
  before_save   :downcase_email
  
  validates :name,  presence: true, length: { maximum: 50 }
  validate
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true, on: :create

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                         WHERE  follower_id = :user_id"
    return_feed = List.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id) + Post.joins(:images).where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id).uniq
    if return_feed.length < 10
      return_feed += List.order("created_at ASC").first(10) + Post.joins(:images).order("created_at ASC").uniq.first(10)
    else
      return_feed = return_feed.first(25).sort { |a,b| a.created_at <=> b.created_at } + (List.order("created_at ASC").first(10) + Post.joins(:images).order("created_at ASC").uniq.first(10)).sort { |a,b| a.created_at <=> b.created_at }
    
    end

    return_feed

  end

  #Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  #Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  #Returns true if the current user is following the other user
  def following?(other_user)
    following.include?(other_user)
  end


  def self.from_omniauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user
      if user.image == nil
        user.update_attribute(:image,auth.info.image)
      end
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        if registered_user.image == nil
          registered_user.update_attribute(:image,auth.info.image)
        end
        return registered_user
      else
        user = User.new(
                            provider:auth.provider,
                            uid:auth.uid,
                            image:auth.info.image,#+"?type=large",
                            name:auth.info.name,
                            email:auth.info.email,
                            admin: false,
                            hard_delete: "",
                            favorites: "",
                            onboard:nil,
                            peapod_access_token:nil,
                            peapod_jsessionid:nil,
                            bio:nil,
                            birthday: nil,
                            password:Devise.friendly_token[0,20],
                            list_buy_code: SecureRandom.hex(16),
                            points:0,
                            instagram:"",
                            website: "",
                            twitter: "",
                            settings: {"guest_list"=>"",
                              "sex"=>"", 
                              "activity_level"=>"s", 
                              "age"=>"", 
                              "min_calories"=>"", 
                              "max_calories"=>"", 
                              "min_fiber"=>"", 
                              "min_vitamin_a"=>"", 
                              "min_vitamin_c"=>"", 
                              "min_calcium"=>"", 
                              "min_iron"=>"", 
                              "max_sugar"=>"500", 
                              "max_sodium"=>"", 
                              "carbohydrates"=>"",
                              "fat"=>"",
                              "protein"=>"",
                              "vegetarian"=>"0", 
                              "pescatarian"=>"0",
                              "red_meat_free"=>"0",
                              "dairy_free"=>"0", 
                              "peanut_free"=>"0", 
                              "gluten_free"=>"0", 
                              "egg_free"=>"0", 
                              "kosher"=>"0", 
                              "store_brand"=>"0", 
                              "organic"=>"0", 
                              "soy_free"=>"0",
                              "unprocessed"=>"0", 
                              "custom"=>"",
                              "height"=>"", 
                              "weight"=>"", 
                              "percentage"=>"",
                              "days"=>"",
                              "budget"=>""}                          
                        )
        user.skip_confirmation!
        user.save!
        return user
      end
    end
  end
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
  
  private
    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
   # def assign_list_buy_code
   #   self.list_buy_code = SecureRandom.hex(16);
   # end
    def skip_confirmation
      self.skip_confirmation!
    end
    
end