class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :name, null: false
      t.string :measured_in, null: false
      t.float :start_from, null: false
      t.float :current_progress, null: false, default: 0
      t.float :target, null: false
      t.string :deadline, null: false
      t.boolean :is_completed, default: false, null: false
      t.bigint :user_id, null: false
      t.timestamps
    end

    add_foreign_key :goals, :users
  end
end
