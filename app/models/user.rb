require 'password_helper'

class User < ActiveRecord::Base

  validates :name, presence: true
  validates :username, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }
  validates :hashed_password, presence: true
  validate :unhashed_password_cannot_be_empty

  include PasswordHelper

  def password=(password)
    @password = password
    if !password.nil?
      self.hashed_password = createHash(password)
    end
  end

  def password
    @password || ""
  end

  def validate_password(password)
    validatePassword(password, self.hashed_password)
  end

  def unhashed_password_cannot_be_empty
    if password.nil?
      errors.add(:password, "password cannot be empty")
    end
  end

end
