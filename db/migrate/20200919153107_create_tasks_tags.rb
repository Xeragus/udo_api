class CreateTasksTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks_tags do |t|
      t.references :task, foreign_key: true
      t.references :tag, foreign_key: true
    end
  end
end
