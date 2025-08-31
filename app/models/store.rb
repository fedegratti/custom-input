class Store < ApplicationRecord
  validates :store_id, :access_token, presence: true
end