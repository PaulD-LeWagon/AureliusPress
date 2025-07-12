class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include additional modules for Devise
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  # Include any additional modules you need
  # e.g., :omniauthable, :confirmable, etc.

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # Enum for user roles
  # Define user roles with a default value
  # You can customize the roles as per your application's requirements
  # Example roles: viewer, user, contributor, subscriber, editor, moderator, admin, superuser
  USER_ROLES = %i[viewer user contributor editor moderator admin superuser].freeze
  validates :role, presence: true, inclusion: { in: USER_ROLES }
  enum :role, USER_ROLES, default: USER_ROLES.first

  # Add this line for Active Storage avatar/profile picture
  has_one_attached :avatar

  # Set a default role for new users
  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role ||= :user
  end
end
