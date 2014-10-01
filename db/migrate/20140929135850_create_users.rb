class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password

      t.string :access_token
      t.string :name, default: ''
      t.string :phone_number, default: ''
      t.string :location, index: true, default: ''

      t.integer :group_id, index: true
      t.timestamps
    end
  end
end
