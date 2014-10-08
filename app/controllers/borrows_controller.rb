class BorrowsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /borrows/999
  def index
    if params[:password] == "999"
      borrows = Borrow.all.map do |borrow|
        borrow.borrow_info
      end

      render json: borrows
    else
      render json: {error: 'wrong password'}
    end
  end

  # GET /admin/999
  def statics
    if params[:password] == "999"
      douban_book_ids = []
      borrower_ids = []
      lender_ids = []
      one_week_ago = Time.now - 7*24*60*60

      if Borrow.all.size > 0
        Borrow.all.map do |borrow|
          if borrow.created_at.time > one_week_ago
            douban_book_ids << borrow.douban_book_id
            borrower_ids << borrow.borrower_id
            lender_ids << borrow.lender_id
          end
        end

        book_info = most_frequent_number_in_array(douban_book_ids)
        hotest_book = Book.where(douban_book_id: book_info[:max_element]).first

        borrower_info = most_frequent_number_in_array(borrower_ids)
        hostest_borrower = User.where(id: borrower_info[:max_element].to_i).first

        lender_info = most_frequent_number_in_array(lender_ids)
        hostest_lender = User.where(id: lender_info[:max_element].to_i).first

        render json:
                   {
                       statics:
                           {
                               hostest_book: {book_name: hotest_book.name, book_image_url: hotest_book.image_href, count: book_info[:max_count]},
                               hostest_borrower: {user_name: hostest_borrower.name, user_email: hostest_borrower.email, count: borrower_info[:max_count]},
                               hostest_lender: {user_name: hostest_lender.name, user_email: hostest_lender.email, count: lender_info[:max_count]}
                           }
                   }
      else
        render json:
                   {
                       statics: "no borrow records."
                   }
      end
    else
      render json: {error: 'wrong password'}
    end
  end

  # POST /borrow_book
  def create
    borrow = Borrow.new(borrow_params)
    if borrow.save
      render json: {result: 'Borrow request sent success!'}
    else
      render json: borrow.errors, status: :unprocessable_entity
    end
  end

  private

  def borrow_params
    params.require(:borrow).permit(:douban_book_id, :borrower_id, :lender_id)
  end

  def most_frequent_number_in_array(original_array)
    uniq_array = original_array.uniq
    max_count = original_array.count(original_array[0])
    max_element = original_array[0]

    uniq_array.each do |uniq_element|
      count = original_array.count(uniq_element)
      if count > max_count
        max_count = count
        max_element = uniq_element
      end
    end

    {max_element: max_element, max_count: max_count}
  end

end