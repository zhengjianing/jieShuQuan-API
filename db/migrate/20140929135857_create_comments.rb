class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :douban_book_id, index: true
      t.text :content
      t.string :user_name, default: ''

      t.timestamps
    end
  end
end
