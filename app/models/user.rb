class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :tutor, dependent: :destroy
  has_one :student, dependent: :destroy

  # Validations
  validates :timezone, presence: true
end
