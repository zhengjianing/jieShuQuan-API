class Book < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :douban_book_id

  def add_book_success_results
    {
        user_id: self.user_id.to_s,
        douban_book_id: self.douban_book_id,
        available: self.available,
        name: self.name,
        authors: self.authors,
        image_href: self.image_href,
        description: self.description,
        author_info: self.author_info,
        price: self.price,
        publisher: self.publisher,
        publish_date: self.publish_date,
        created_at: self.created_at.time.strftime('%Y-%m-%d')
    }
  end
end
