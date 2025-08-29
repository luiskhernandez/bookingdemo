class LessonType < ApplicationRecord
  belongs_to :tutor

  validates :title, presence: true, uniqueness: { scope: :tutor_id }
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
end
