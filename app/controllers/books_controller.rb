class BooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /books/999
  def index
    if params[:password] == "999"
      render json: Book.all
    else
    render json: {error: 'wrong password'}
    end
  end

  def show
    redirect_to "http://book.douban.com/subject/#{params[:douban_book_id]}/"
  end

  # POST /add_book
  def create
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    if user.has_book?(params[:douban_book_id])
      render json: {error: "Already has the book for the user"}, status: :unprocessable_entity
      return
    end

    book = Book.new(book_params)
    if book.save
      render json: {book: book.add_book_success_results}
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  # PUT /remove_book
  def remove
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    book = user.books.select {|book| book.douban_book_id == params[:douban_book_id]}.first

    if book.nil?
      render json: {error: "Can't find book for user!"}, status: 404
      return
    end

    if book.destroy!
      render json: {removed: 'success'}
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end


  # PUT /change_status
  def update
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    book = user.books.select {|book| book.douban_book_id == params[:douban_book_id]}.first

    if book.nil?
      render json: {error: "Can't find book for user"}, status: 404
      return
    end

    book.available = params[:available]
    if book.save
      render json: {book: book.add_book_success_results}
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end


  # GET /friendsWithBook/:douban_book_id/forUser/:user_id
  def get_friends_with_book_for_user
    user = User.find(params[:user_id].to_i)
    if user.nil? || user.group.nil?
      render json: {error: "No user or group found!"}, status: 404
      return
    end

    books = Book.where({douban_book_id: params[:douban_book_id]})
    if books.empty?
      render json: {douban_book_id: params[:douban_book_id], friends: []}
      return
    end

    all_people_has_book = []
    books.each do |book|
      all_people_has_book << User.find(book.user_id)
    end

    friends = all_people_has_book.select do |people|
      people.group != nil && people.group.name == user.group.name && people.id.to_s != params[:user_id]
    end

    friends_result = friends.map do |friend|
      friend.friend_info.merge({available: Book.where({douban_book_id: params[:douban_book_id], user_id: friend.id.to_s}).first.available})
    end

    results = {douban_book_id: params[:douban_book_id], friends: friends_result}
    render json: results
  end

  private

  def book_params
    params.require(:book).permit(:user_id, :douban_book_id, :available, :name, :authors, :image_href,
                                 :description, :author_info, :price, :publisher, :publish_date)
  end
end