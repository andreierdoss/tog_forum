Tog Forum: a work in progress
========

Tog forums support: not ready for prime time! 
I started working on this but it is not yet complete. I realize that the model Post conflicts with a Post model in tog_conversatio. I'll fix it when I can, but in the meantime, if you really need it fixed, you can always fork this project :)

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
    migrate_plugin "tog_forum", 1
  end

  def self.down
    migrate_plugin "tog_forum", 0
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

[http://github.com/jacqui/tog_forum](http://github.com/jacqui/tog_forum)


Copyright (c) 2008 Jacqui Maher, released under the MIT license
