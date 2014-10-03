class Comment < ActiveRecord::Base

  validates_presence_of :content

  def comment_info
    {
        group_name: self.group_name,
        user_name: self.user_name,
        comment_date: self.created_at.time.strftime('%Y-%m-%d'),
        content: self.content
    }
  end
end
