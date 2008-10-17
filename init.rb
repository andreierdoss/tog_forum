require_plugin 'tog_core'

Tog::Interface.sections(:site).add "Forums", "/forums"        

Tog::Plugins.settings :tog_forum, :header => "Suckramento Forums"
