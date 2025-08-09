# == Schema Information
#
# Table name: aurelius_press_users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string
#  last_name              :string
#  age                    :integer
#  role                   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  status                 :integer          default("active"), not null
#
class AureliusPress::User < ApplicationRecord
  self.table_name = "aurelius_press_users"
  # Set a default role for new users
  after_initialize :set_default_role, if: :new_record?
  # Callback to set username if it's not present
  before_validation :set_username_from_email, on: :create # Only run on initial creation
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include additional modules for Devise
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  # Include any additional modules you need
  # e.g., :omniauthable, :confirmable, etc.

  USER_ROLES = %i[ reader user moderator admin superuser ].freeze

  DEFAULT_ROLE = USER_ROLES.first

  # Associations
  # Define separately if needed but Documents may suffice for now
  # has_many :groups, class_name: "Group", foreign_key: "user_id"
  # has_many :pages, class_name: "Page", foreign_key: "user_id", dependent: :destroy
  # has_many :atomic_blog_posts, class_name: "AtomicBlogPost", foreign_key: "user_id", dependent: :destroy
  # has_many :blog_posts, class_name: "BlogPost", foreign_key: "user_id", dependent: :destroy
  # has_many :comments, class_name: "Comment", foreign_key: "user_id", dependent: :destroy
  has_many :documents, dependent: :destroy, class_name: "AureliusPress::Document::Document", inverse_of: :user
  # Has many Likes
  has_many :likes, dependent: :destroy, class_name: "AureliusPress::Community::Like", inverse_of: :user
  # Active Storage for avatar/profile picture
  has_one_attached :avatar

  # Make the BIO field a rich text field
  has_rich_text :bio

  has_many :aurelius_press_community_group_memberships, # Use the full namespaced name for clarity
           class_name: "AureliusPress::Community::GroupMembership",
           foreign_key: :user_id, # This is the foreign key on group_memberships table
           dependent: :destroy

  has_many :groups, through: :aurelius_press_community_group_memberships,
                    class_name: "AureliusPress::Community::Group",
                    source: :group

  # Enum for user roles
  # Define user roles with a default value
  enum :role, USER_ROLES, default: DEFAULT_ROLE

  # Enum for user status
  enum :status, [
    :active,
    :inactive,
    :banned,
    :suspended,
    :pending,
  ], default: :active

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :role, presence: true
  validates :status, presence: true
  # validates :password, length: { minimum: 6 }, allow_blank: true
  # validates :password_confirmation, length: { minimum: 6 }, allow_blank: true

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def set_username_from_email
    if username.blank? && email.present?
      self.username = email.split("@").first # Takes the part before '@'
    end
  end

  def set_default_role
    self.role ||= DEFAULT_ROLE
  end
end
