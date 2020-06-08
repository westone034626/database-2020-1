class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :mentees, class_name: "User", foreign_key: "mentor_id", dependent: :nullify

  belongs_to :mentor, class_name: "User", optional: true

  has_many :reads, dependent: :destroy
  has_many :books, through: :reads
end
