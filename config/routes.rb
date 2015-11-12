Rails.application.routes.draw do

  # books routes
  # ------------------------------------------------------------------------------------------------
  # api
  get 'books/:password' => 'books#index'
  post 'add_book' => "books#create"
  put 'remove_book' => "books#remove"
  put 'change_status' => "books#update"
  get 'friendsWithBook/:douban_book_id/forUser/:user_id' => 'books#get_friends_with_book_for_user'

  # views
  get 'book/:douban_book_id' => 'books#show'
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


  # BorrowRecord
  # ------------------------------------------------------------------------------------------------
  post 'create_borrow_record' => 'borrow_records#create'
  post 'approve_borrow_record' => 'borrow_records#approve'
  post 'decline_borrow_record' => 'borrow_records#decline'
  post 'return_borrow_record' => 'borrow_records#return'

  get 'borrower_records' => 'borrow_records#borrower_records'
  get 'lender_records' => 'borrow_records#lender_records'

  # ------------------------------------------------------------------------------------------------



  # ----------------------------------- remove later -------------------------------------------------------------
  # will be replaced by BorrowRecord, but can't remove it since the old version is still using it
  # borrow routes
  # ------------------------------------------------------------------------------------------------
  post 'borrow_book' => 'borrows#create'

  get 'borrows/:password' => 'borrows#index'
  get 'admin/:password' => 'borrows#statics'

  # ------------------------------------------------------------------------------------------------

end
