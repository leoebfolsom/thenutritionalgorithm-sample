class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :list
  has_many :images, :dependent => :delete_all
  has_many :comments, as: :commentable
  
end