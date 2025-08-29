class Tutor < ApplicationRecord
  belongs_to :user
  has_many :lesson_types, dependent: :destroy
  belongs_to :default_lesson_type, class_name: "LessonType", optional: true

  validates :display_name, presence: true
  validates :bio, presence: true
  validates :timezone, presence: true

  def allow_multi_offers?
    settings["allow_multi_offers"] == true
  end

  validate :single_offer_unless_allowed

  private

  def single_offer_unless_allowed
    return if allow_multi_offers?
    return if lesson_types.size <= 1

    errors.add(:base, "Only one lesson type allowed for this profile")
  end
end
