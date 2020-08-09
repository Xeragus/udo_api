class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: { unique: true }
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :dob

      t.timestamps
    end
  end
end
