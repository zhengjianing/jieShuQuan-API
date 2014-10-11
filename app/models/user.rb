class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader

  has_many :books
  belongs_to :group

  validates_presence_of :email
  validates_presence_of :password

  validates_uniqueness_of :email
  validates_format_of :email, :message => "email format not correct!", :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def User.has_no_permission?(user_id, access_token)
    User.where({id: user_id, access_token: access_token}).empty?
  end

  def User.exist?(user_id)
    !User.find(user_id).nil?
  end

  def group_name
    self.group.nil? ? '' : self.group.name
  end

  def book_count
    User.find(self.id).books.size.to_s
  end

  def friend_count
    (self.group.nil? ? 0 : self.group.users.size - 1).to_s
  end

  def register_success_result
    {
        user_id: self.id.to_s,
        user_email: self.email,
        access_token: self.access_token,
        user_name: self.name,
        location: self.location,
        phone_number: self.phone_number,
        avatar_url: self[:avatar_url],
        book_count: self.book_count,
        friend_count: self.friend_count,
        group_name: self.group_name
    }
  end

  def show_users
    {
        user_id: self.id.to_s,
        user_email: self.email,
        user_name: self.name,
        location: self.location,
        phone_number: self.phone_number,
        avatar_url: self[:avatar_url],
        book_count: self.book_count,
        friend_count: self.friend_count,
        group_name: self.group_name
    }
  end

  def friend_info
    {
        friend_id: self.id.to_s,
        friend_name: self.name,
        friend_email: self.email,
        friend_location: self.location,
        friend_phone_number: self.phone_number,
        friend_avatar_url: self[:avatar_url],
        book_count:self.book_count
    }
  end


  def has_book?(douban_book_id)
    self.books.select {|book| book.douban_book_id == douban_book_id }.size > 0
  end

  def has_permission?(access_token)
    self.access_token == access_token
  end
end