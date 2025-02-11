require 'jwt'
class User < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :created_projects, class_name: 'Project', foreign_key: "manager_id"
  has_many :bugs, foreign_key: :qa_id

  enum user_type: {developer:0 , manager:1 , qa:2 , user:3 , admin:4 }

  scope :not_admin_and_manager, -> { where.not(user_type: ['manager', 'admin'])}

  def active_for_authentication?
    super && enabled?
  end

  def inactive_message
    enabled? ? super : :account_disabled
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null


  validates :name, presence: true
  validates :email, uniqueness: true

    def generate_jwt
      JWT.encode(
        { id: id, exp: 7.days.from_now.to_i },
        Rails.application.credentials.secret_key_base,
        'HS256'
      )
    end
end
