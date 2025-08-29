class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.jsonb :settings, default: {}

      t.timestamps
    end
  end
end
