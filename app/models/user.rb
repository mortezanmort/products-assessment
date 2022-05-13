class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, message: 'Password must be at least 8 characters' }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must match format email@domain.com' },
    uniqueness: { message: 'An account with this email already exists'}
end
