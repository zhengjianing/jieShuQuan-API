class CreateBorrowRecords < ActiveRecord::Migration
  def change
    create_table :borrow_records do |t|
      t.string :book_id
      t.string :borrower_id
      t.string :lender_id

      t.string :status
      t.datetime :application_time
      t.datetime :borrow_time
      t.datetime :return_time

      t.timestamps
    end
  end
end
