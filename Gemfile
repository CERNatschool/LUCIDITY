source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'mysql2', '~> 0.3.13'

gem 'thin', '~> 1.5.1'

gem 'rubyzip', '~> 0.9.9'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '~> 0.12.0', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'sass-rails', '~> 3.2.3'
end

gem 'bluecloth', '~> 2.2.0'

gem 'jquery-rails', '~> 2.0'

# For attachments
gem 'paperclip', :git => 'https://github.com/thoughtbot/paperclip.git', :branch => 'master'

# For Amazon S3 storage (via Paperclip)
gem 'aws-sdk'

# For Amazon SES emailing
gem 'aws-ses', '~>0.4.4', require: 'aws/ses'



gem "hobo", "= 2.0.1"

# Hobo has a lot of assets.   Stop cluttering the log in development mode.
gem "quiet_assets", :group => :development
# Hobo's version of will_paginate is required.
gem "will_paginate", :git => "git://github.com/Hobo/will_paginate.git"
gem "hobo_clean", "2.0.1"
gem "hobo_jquery_ui", "2.0.1"
gem "jquery-ui-themes", "~> 0.0.4"
gem "hobo_clean_admin", "2.0.1"
gem 'hobo_paperclip', :git => "https://github.com/Hobo/hobo_paperclip.git", :branch => 'master'
