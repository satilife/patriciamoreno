# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  email                  :string           not null
#  phone_number           :string
#  birthdate              :date
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  password_set           :boolean          default(TRUE)
#  avatar                 :string
#  uploaded_avatar        :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_first_name            (first_name)
#  index_users_on_last_name             (last_name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include Authenticatable
  include Avatarable

  mount_uploader :uploaded_avatar, AvatarUploader

  auto_strip_attributes :first_name, :last_name, :email

  before_save :titleize_name
  before_save :downcase_email

  has_many :identities,   dependent: :destroy

  validates_presence_of :first_name, :last_name

  scope :ordered,         -> { order(:first_name, :last_name) }
  scope :admin,           -> { where(admin: true) }
  scope :standard,        -> { where(admin: false) }

  scope :for_review,      -> { eager_load(:identities) }
  scope :for_listing,     -> { for_review.ordered }

  def self.search(search)
    where('first_name ILIKE :search OR last_name ILIKE :search OR email ILIKE :search', search: "%#{search.strip}%")
  end

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name.chr}#{last_name.chr}"
  end

  def abbr_name
    "#{first_name} #{last_name.chr}."
  end

  def password_required?
    return false unless password_set?
    super
  end

  def photo
    return uploaded_avatar.url if uploaded_avatar.present?
    avatar
  end

  def photo?
    uploaded_avatar.present? || avatar.present?
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def titleize_name
    self.first_name = first_name.titleize
    self.last_name  = last_name.titleize
  end
end
