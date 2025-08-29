class CreateLessonTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_types, id: :uuid do |t|
      t.references :tutor, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.integer :duration_minutes, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :lesson_types, [:tutor_id, :title], unique: true
  end
end
