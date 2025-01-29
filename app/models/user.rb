class User < ApplicationRecord
<<<<<<< Updated upstream
  enum user_type: {developer:0 , manager:1 , qa:2 }
=======
  enum user_type: {developer:0 , manager:1 , qa:2 , user:3 , admin:4 }

  def active_for_authentication?
    super && enabled?
  end

  def inactive_message
    enabled? ? super : :account_disabled
  end


>>>>>>> Stashed changes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, uniqueness: true
end
