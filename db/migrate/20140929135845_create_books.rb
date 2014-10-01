class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :douban_book_id, index: true, null: false
      t.string :name, default: ''
      t.string :authors, default: ''
      t.string :image_href, default: ''
      t.string :price, default: ''
      t.string :publisher, default: ''
      t.string :publish_date, default: ''
      t.text :description, default: ''
      t.text :author_info, default: ''

      t.boolean :available, default: false

      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
