class User < ApplicationRecord
  has_secure_password   # enables password_digest authentication

  # Pagination
  paginates_per 10

  # Associations
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_one_attached :avatar

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validate :avatar_content_type
  validate :avatar_size

  private

  def avatar_content_type
    return unless avatar.attached?

    unless avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, "must be a valid image format (JPEG, PNG, or GIF)")
    end
  end

  def avatar_size
    return unless avatar.attached?

    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, "should be less than 5MB")
    end
  end
end
