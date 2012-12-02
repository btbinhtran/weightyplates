class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :workouts, dependent: :destroy

  has_many :exercise_stats, dependent: :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :default_unit

  validates :default_unit, presence: true,
                           inclusion: { in: %w(lb kg), message: "%{value} is not a valid weight system" }
end
