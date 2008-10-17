Tog Forum
========

Tog forums support

Included functionality
-----------------------

* Forum, topics and posts
* Customizable access control (login required)
* Integration with authentication_system via tog_user
* Administration interface (utilizing existing admin? rules in tog_user)

Resources
=========

Plugin requirements
-------------------
* tog_user
* will_paginate


Install
-------

If you used the command <code>togify</code> to install tog, then you already have tog_user installed.

If not, install it like any other plugin:

  
* Install plugin form source:

<pre>
ruby script/plugin install git@github.com:jacqui/tog_forum.git

</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_forum
</pre>

	  with the following content:

<pre>
class InstallTogForum < ActiveRecord::Migration
  def self.up
    create_table :forums do |t|
      t.string   :title
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
</pre>

* Add tog_forums's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_forum'
</pre> 

* And finally...

<pre> 
rake db:migrate
</pre> 

More
-------

[http://github.com/tog/tog_user](http://github.com/tog/tog_user)


Copyright (c) 2008 Jacqui Maher, released under the MIT license