class BorrowRecordsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  $BORROW_STATUS = {
      pending: "pending",
      approved: "approved",
      declined: "declined",
      returned: "returned"
  }

  #  ------------------------ 创建一条借书申请  ------------------------
  # POST
  # /create_borrow_record
  def create
    if params[:book_id] == nil || params[:borrower_id] == nil || params[:lender_id] == nil
      render json: {error: '参数缺失：book_id or borrower_id or lender_id'}
      return
    end

    exciting_record = BorrowRecord.where({
                                             book_id: params[:book_id].to_s,
                                             borrower_id: params[:borrower_id].to_s,
                                             lender_id: params[:lender_id].to_s
                                         }).first
    if exciting_record
      render json: {error: '不能重复申请'}
      return
    end

    borrow_record = BorrowRecord.create({
                                            book_id: params[:book_id].to_s,
                                            borrower_id: params[:borrower_id].to_s,
                                            lender_id: params[:lender_id].to_s,
                                            status: $BORROW_STATUS[:pending],
                                            application_time: Time.now
                                        })
    if borrow_record.save!
      render json: {success: '申请成功'}
    else
      render json: {error: '申请失败'}
    end
  end


  #  ------------------------ 同意某个借书申请  ------------------------
  # POST
  # /approve_borrow_record
  def approve
    if params[:book_id] == nil || params[:borrower_id] == nil || params[:lender_id] == nil
      render json: {error: '参数缺失：book_id or borrower_id or lender_id'}
      return
    end

    exciting_record = BorrowRecord.where({
                                             book_id: params[:book_id].to_s,
                                             borrower_id: params[:borrower_id].to_s,
                                             lender_id: params[:lender_id].to_s
                                         }).first
    if !exciting_record
      render json: {error: '借书申请不存在'}
      return
    end

    book = Book.where(douban_book_id: params[:book_id].to_s).first
    book.available = false
    book.save!

    exciting_record.status = $BORROW_STATUS[:approved]
    exciting_record.borrow_time = Time.now

    if exciting_record.save!
      render json: {success: '修改成功'}
    else
      render json: {error: '修改失败'}
    end
  end


  #  ------------------------ 拒绝某个借书申请  ------------------------
  # POST
  # /decline_borrow_record
  def decline
    if params[:book_id] == nil || params[:borrower_id] == nil || params[:lender_id] == nil
      render json: {error: '参数缺失：book_id or borrower_id or lender_id'}
      return
    end

    exciting_record = BorrowRecord.where({
                                             book_id: params[:book_id].to_s,
                                             borrower_id: params[:borrower_id].to_s,
                                             lender_id: params[:lender_id].to_s
                                         }).first
    if !exciting_record
      render json: {error: '借书申请不存在'}
      return
    end

    exciting_record.status = $BORROW_STATUS[:declined]

    if exciting_record.save!
      render json: {success: '修改成功'}
    else
      render json: {error: '修改失败'}
    end
  end


  #  ------------------------ 归还某个借书申请  ------------------------
  # POST
  # /return_borrow_record
  def return
    if params[:book_id] == nil || params[:borrower_id] == nil || params[:lender_id] == nil
      render json: {error: '参数缺失：book_id or borrower_id or lender_id'}
      return
    end

    exciting_record = BorrowRecord.where({
                                             book_id: params[:book_id].to_s,
                                             borrower_id: params[:borrower_id].to_s,
                                             lender_id: params[:lender_id].to_s
                                         }).first
    if !exciting_record
      render json: {error: '借书申请不存在'}
      return
    end

    book = Book.where(douban_book_id: params[:book_id].to_s).first
    book.available = true
    book.save!

    exciting_record.status = $BORROW_STATUS[:returned]
    exciting_record.return_time = Time.now

    if exciting_record.save!
      render json: {success: '修改成功'}
    else
      render json: {error: '修改失败'}
    end
  end


  #  ------------------------ 获取某个人向别人发送的所有借书申请  ------------------------
  # GET
  # /borrower_records?borrower_id=1
  def borrower_records
    if params[:borrower_id] == nil
      render json: {error: '参数缺失：borrower_id'}
      return
    end

    borrowRecords = BorrowRecord.where(borrower_id: params[:borrower_id].to_s).sort{|l,r| l.updated_at <=> r.updated_at}
    results = borrowRecords.map {|record| record.displayed_value}

    render json: results
  end


  #  ------------------------ 获取向某个人发送的所有借书申请  ------------------------
  # GET
  # /lender_records?lender_id=1
  def lender_records
    if params[:lender_id] == nil
      render json: {error: '参数缺失：lender_id'}
      return
    end

    borrowRecords = BorrowRecord.where(lender_id: params[:lender_id].to_s)
    results = borrowRecords.map {|record| record.displayed_value}

    render json: results
  end

end