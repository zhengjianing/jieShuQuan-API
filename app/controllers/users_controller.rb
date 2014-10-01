class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token

# GET /users/999
  def index
    if params[:password] == '999'
      @users = User.all.map do |user|
        user.register_success_result
      end
      render json: @users
    else
      render json: {error: 'wrong password'}
    end
  end

# GET 'books_by_user/:user_id'
  def get_books_by_user
    user_id = params[:user_id].to_i
    user = User.find(user_id)

    if user.nil?
      render json: user.errors, status: 404
    else
      books = user.books.select{ |book| book.user_id == user_id}.map do |book|
        book.add_book_success_results
      end
      results = {user_id: params[:user_id], books: books}
      render json: results
    end
  end


#GET 'friends_by_user/:user_id'
  def get_friends_by_user
    user_id = params[:user_id].to_i

    if !User.exist?(user_id) || User.find(user_id).group.nil?
      render json: {error: "No user or group found with user_id: #{user_id}."}, status: 404
      return
    end

    friends = User.find(user_id).group.users.select{|user| user.id != user_id}.map do |friend|
      friend.friend_info
    end

    results = {user_id: params[:user_id], friends: friends}
    render json: results
  end

# POST /register
  def register
    email_suffix = email_suffix_by_email(params[:email])
    user_params = {email: params[:email], password: params[:password], access_token: create_access_token}

    if is_a_personal_email?(email_suffix)
      user = User.new(user_params)
    else
      group = get_or_create_group_by_email_suffix(email_suffix)
      user = group.users.create(user_params)
    end

    if user.save
      render json: user.register_success_result
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

# POST /login
  def login
    user = User.where({email: params[:email], password: params[:password]}).first

    if user.nil?
      render json: user.errors, status: 404
    else
      render json: user.register_success_result
    end
  end

# POST /upload_avatar
  def upload_avatar
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    uploaded_io = params[:avatar_file]
    if !uploaded_io.nil? && uploaded_io.content_type.match('image')
      File.open(Rails.root.join('public/assets', uploaded_io.original_filename), 'wb') do |f|
        f.write(uploaded_io.read)
      end

      render json: {result: "uploaded success!"}
    else
      render json: {result: "uploaded fail!"}, status: 500
    end
  end

  # POST /change_username
  def change_username
    user = User.find(params[:user_id].to_i)

    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    user.name = params[:user_name]
    user.save!
    render json: {result: "Change username success!"}
  end

# POST /change_location
  def change_location
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    user.location = params[:location]
    user.save!
    render json: {result: "Change location success!"}
  end

  # POST /change_phone_number
  def change_phone_number
    user = User.find(params[:user_id].to_i)
    unless user.has_permission?(params[:access_token])
      render json: {error: "User authentication failed."}, status: :unauthorized
      return
    end

    user.phone_number = params[:phone_number]
    user.save!
    render json: {result: "Change phone_number success!"}
  end

  private

  def get_or_create_group_by_email_suffix email_suffix
    group = Group.where(name: email_suffix).first
    group.nil? ? Group.create(name: email_suffix) : group
  end

  def is_a_personal_email? email_suffix
    %w(126 163 gmail qq sina yahoo sohu).include?(email_suffix)
  end

  def email_suffix_by_email email
    email.split('@')[1].split('.')[0]
  end

  def create_access_token
    randstring = ''
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    1.upto(20) { |i| randstring << chars[rand(chars.size-1)] }
    randstring
  end

end