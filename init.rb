require_plugin 'tog_core'

Tog::Interface.sections(:admin).add "Forums", "/admin/forums"        
Tog::Interface.sections(:site).add "Forums", "/forums"


Tog::Plugins.settings :tog_forum, "forums.list.page.size"        => "10",
                                  "topics.list.page.size"        => "20"
                                   
require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end