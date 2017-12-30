class Login < ApplicationRecord
  has_many :accounts
  belongs_to :customer
end
