class CreateBorrows < ActiveRecord::Migration
  def change
    create_table :borrows do |t|
      t.string :douban_book_id, index: true
      t.string :borrower_id, index: true
      t.string :lender_id, index: true

      t.timestamps
    end
  end
end
