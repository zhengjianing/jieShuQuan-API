class Comment < ActiveRecord::Base

  validates_presence_of :content

  def comment_info
    {
        user_name: self.user_name,
        comment_date: self.created_at.time.strftime('%Y-%m-%d %H:%M:%S'),
        content: self.content
    }
  end
end
