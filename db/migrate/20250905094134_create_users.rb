class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.string :phone
      t.boolean :is_active, default: true
      t.datetime :last_login_at
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end
    add_index :users, :name                  # optional
    add_index :users, :email, unique: true   # required
    add_index :users, :phone, unique: true   # optional
    add_index :users, :is_active             # optional
  end
end
