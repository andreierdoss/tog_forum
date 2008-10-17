class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  validates_length_of :body, :minimum => 4
  validates_presence_of :body

  acts_as_abusable

  def after_create
    topic.update_attributes :last_post_at => created_at,
                            :last_post_by => user_id
  end
end