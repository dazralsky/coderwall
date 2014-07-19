class Users::Github::Profile < ActiveRecord::Base
  belongs_to :user
  has_many :followers, class_name: 'Users::Github::Profiles::Follower' , foreign_key: :follower_id  , dependent: :delete_all
  has_many :repositories, :class_name => 'Users::Github::Repository' , foreign_key: :owner_id
end
