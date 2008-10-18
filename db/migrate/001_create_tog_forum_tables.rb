class CreateTogForumTables < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string   :title
      t.integer  :user_id
      t.timestamps
    end
    
    create_table :topics do |t|
      t.integer  :forum_id
      t.integer  :user_id
      t.text     :title
      t.datetime :last_post_at
      t.integer  :last_post_by
      t.timestamps
    end
    
    create_table :posts do |t|
      t.integer  :topic_id
      t.integer  :user_id
      t.text     :body
      t.timestamps
    end

  end

  def self.down
    drop_table :forums
    drop_table :topics
    drop_table :posts
  end
end
