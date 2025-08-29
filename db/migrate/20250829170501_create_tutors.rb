class CreateTutors < ActiveRecord::Migration[8.0]
  def change
    create_table :tutors, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :display_name, null: false
      t.text :bio
      t.string :timezone, default: "UTC"
      t.jsonb :settings, default: {}
      t.uuid :default_lesson_type_id

      t.timestamps
    end
  end
end
