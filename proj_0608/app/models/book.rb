class Book < ApplicationRecord
    has_many :reads, dependent: :destroy
    has_many :users, through: :reads
end
