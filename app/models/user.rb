require 'jwt'
class User < ApplicationRecord
  include AuthenticationConcern
  include Devise::JWT::RevocationStrategies::JTIMatcher
  before_create :set_jti

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :created_projects, class_name: 'Project', foreign_key: "manager_id"
  has_many :bugs, foreign_key: :qa_id

  enum user_type: { developer: 0, manager: 1, qa: 2, user: 3, admin: 4 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :name, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true

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
