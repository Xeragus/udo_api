class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.bigint :user_id, default: :null
    end

    add_foreign_key :tags, :users
  end
end
