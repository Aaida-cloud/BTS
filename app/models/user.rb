require 'jwt'
class User < ApplicationRecord
  before_create :set_jti

  include AuthenticationConcern
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :created_projects, class_name: 'Project', foreign_key: "manager_id"
  has_many :bugs, foreign_key: :qa_id, dependent: :destroy

  enum user_type: { developer: 0, manager: 1, qa: 2, user: 3, admin: 4 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true

  PER_PAGE = 5
  DEV_PROJECT_PER_PAGE = 5
  BUG_PER_PAGE = 5
  EXCLUDED_USER_TYPES = ['manager', 'admin']
  IGNORED_USER_TYPE = ["admin"]


  def generate_jwt
    JWT.encode(
      { id: id, jti: jti, exp: 7.days.from_now.to_i },
      Rails.application.credentials.secret_key_base,
      'HS256'
    )
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
