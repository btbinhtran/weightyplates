class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :default_unit
  # attr_accessible :title, :body

  validates :default_unit, presence: true,
                           inclusion: { in: %w(lb kg), message: "%{value} is not a valid weight system" }
end
