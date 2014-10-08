class Borrow < ActiveRecord::Base

  validates_presence_of :douban_book_id
  validates_presence_of :borrower_id

  def borrow_info
    {
        id: self.id,
        douban_book_id: self.douban_book_id,
        borrower_id: self.borrower_id,
        lender_id: self.lender_id,
        borrow_date: self.created_at.time.strftime('%Y-%m-%d %H:%M:%S'),
    }
  end

end
