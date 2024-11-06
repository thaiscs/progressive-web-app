class User < ApplicationRecord
  has_many :locations, dependent: :destroy
end
