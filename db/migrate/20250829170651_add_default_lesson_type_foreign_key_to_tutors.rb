class AddDefaultLessonTypeForeignKeyToTutors < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :tutors, :lesson_types, column: :default_lesson_type_id
  end
end
