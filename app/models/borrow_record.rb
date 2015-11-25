class BorrowRecord < ActiveRecord::Base

  def displayed_value
    borrower = User.where(id: self.borrower_id.to_i).first
    lender = User.where(id: self.lender_id.to_i).first
    book = lender.books.select {|book| book.douban_book_id.to_i == self.book_id.to_i }.first

    {
        book_name: non_nil_value_for(book, "name"),
        book_image_url: non_nil_value_for(book, "image_href"),
        borrower_name: non_nil_value_for(borrower, "name"),
        lender_name: non_nil_value_for(lender, "name"),
        status: self.status,
        application_time: non_nil_value_for(self, "application_time"),
        borrow_time: non_nil_value_for(self, "borrow_time"),
        return_time: non_nil_value_for(self, "return_time")
    }
  end

  # private

  def non_nil_value_for object, property
    return nil if object.nil?
    value = object[property.to_sym]
    value.is_a?(Time) ? value.strftime('%Y-%m-%d %H:%M:%S') : value
  end

end
