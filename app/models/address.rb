class Address < ApplicationRecord
  belongs_to :order

  validates :city, :state, :country, :address1, presence: true
  validates :address1, :address2, length: { maximum: 250, message: 'Address must be less than 250 characters' }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Email must match format email@domain.com' },
    uniqueness: { message: 'An account with this email already exists', case_sensitive: false }
end
