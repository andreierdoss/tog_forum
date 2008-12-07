Factory.sequence :login do |n| 
  "user#{n}"
end

Factory.define :user do |u|
  u.salt '7ad651b39a1a9e78b87540d91d30ad676b5d754d'
  u.last_login_at ''
  u.zip '10012'
  u.updated_at 'Thu Nov 06 17:58:48 UTC 2008'
  u.activated_at ''
  u.sucks ''
  u.crypted_password '2f97d4bdfe9686d924e43669b52998b3c6749155'
  u.memberid ''
  u.deleted_at ''
  u.remember_token_expires_at ''
  u.admin 'true'
  u.activation_code '39febbfaf26bc6072679effc7848c0608a605de4'
  u.password_reset_code '10687e1e14e0beaace1f22b91e608d884343696a'
  u.gender 'female'
  u.description 'all about me'
  u.remember_token ''
  u.birthday '1977-08-12'
  u.login {|a| a.login = Factory.next(:login) }
  u.sucksNot ''
  u.state 'active'
  u.email {|a| "#{a.login}@example.com".downcase }
  u.created_at 'Thu Oct 30 08:18:43 UTC 2008'
end

Factory.define :forum, :class => TogForum::Forum do |f|
  f.title       "Suckramento Forums"
  f.legacyid    "5"
  f.association :user
  f.created_at  Time.now.to_formatted_s(:db)
  f.updated_at  Time.now.to_formatted_s(:db)
end

Factory.define :topic, :class => TogForum::Topic do |t|
  t.title         "Something Awful"
  t.body          "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur cursus, sem et pellentesque rutrum, lectus dolor imperdiet eros, nec gravida tortor tellus cursus lacus. Etiam at ligula. Vivamus fringilla leo vitae metus. Phasellus sed metus eget nisi feugiat varius. Sed pretium enim a lectus. Vestibulum eu dolor."
  t.legacyid      nil
  t.last_post_at  Time.now.to_formatted_s(:db)
  t.association   :last_post_by, :factory => :user
  t.association   :forum
  t.association   :user
  t.created_at    Time.now.to_formatted_s(:db)
  t.updated_at    Time.now.to_formatted_s(:db)
end

Factory.define :post, :class => TogForum::Post do |p|
  p.body        "Suspendisse potenti. Fusce auctor libero vel felis. Nunc sed risus dictum purus sollicitudin faucibus. Nullam tristique, nunc in pulvinar varius, ipsum arcu sodales nunc, in pulvinar elit quam sit amet diam. Donec congue, arcu eget mollis volutpat, odio urna egestas ipsum, nec mattis odio nibh et sem. Sed tempor aliquet diam. Nunc pharetra arcu eget mi. In hac habitasse platea dictumst."
  p.legacyid    nil
  p.association :topic
  p.association :user
  p.created_at  Time.now.to_formatted_s(:db)
  p.updated_at  Time.now.to_formatted_s(:db)
end