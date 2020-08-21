class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :description
      t.string :deadline, null: false
      t.boolean :is_completed, default: false, null: false
      t.bigint :user_id, null: false
      t.timestamps
    end

    add_foreign_key :tasks, :users
  end
end
