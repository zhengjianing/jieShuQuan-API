Rails.application.routes.draw do

  # books routes
  # ------------------------------------------------------------------------------------------------
  get 'books/:password' => 'books#index'
  post 'add_book' => "books#create"
  put 'remove_book' => "books#remove"
  put 'change_status' => "books#update"
  get 'friendsWithBook/:douban_book_id/forUser/:user_id' => 'books#get_friends_with_book_for_user'
  # ------------------------------------------------------------------------------------------------


  # users routes
  # ------------------------------------------------------------------------------------------------
  get 'users/:password' => 'users#index'
  post 'register' => 'users#register'
  post 'login' => 'users#login'
  post 'upload_avatar' => 'users#upload_avatar'
  post 'change_username' => 'users#change_username'
  post 'change_location' => 'users#change_location'
  post 'change_phone_number' => 'users#change_phone_number'
  get 'books_by_user/:user_id' => 'users#get_books_by_user'
  get 'friends_by_user/:user_id' => 'users#get_friends_by_user'
  # ------------------------------------------------------------------------------------------------


  # groups routes
  # ------------------------------------------------------------------------------------------------
  get 'groups/:password' => 'groups#index'
  # ------------------------------------------------------------------------------------------------


  # comments routes
  # ------------------------------------------------------------------------------------------------
  get 'comments/:password' => 'comments#index'
  post 'comments/create' => 'comments#create'
  get 'comments_for_book/:douban_book_id' => 'comments#comments_for_book'
  # ------------------------------------------------------------------------------------------------

end
