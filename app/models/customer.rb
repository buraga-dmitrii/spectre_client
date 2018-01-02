class Customer < ApplicationRecord
  belongs_to :user
  has_many :logins, dependent: :destroy
end
