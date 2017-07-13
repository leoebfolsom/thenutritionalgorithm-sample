source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '~> 5.1', '>= 5.1.1'
gem 'bcrypt'#,               '3.1.7'
gem 'bootstrap-sass'#, '3.2.0.0' #recommended by railstutorial.org
gem 'twitter-bootstrap-rails'
#gem 'jquery_mobile_rails'
gem 'devise'
gem 'rack'#, '~> 1.6', '>= 1.6.4'
gem 'omniauth-facebook'
gem 'font-awesome-rails', '~> 4.6', '>= 4.6.2.0'
gem 'sass-rails'#,   '5.0.2'
gem 'uglifier'#,     '2.5.3'
gem 'coffee-rails'#, '4.1.0'
gem 'jquery-rails'#, '4.0.3'
gem 'jbuilder'#,     '2.2.3'
gem 'yaml_db'
gem 'pg'
gem 'stripe'
gem 'rabl'
# Also add either `oj` or `yajl-ruby` as the JSON parser
gem 'oj'

gem 'aws-sdk', '~> 2'
gem 'dotenv-rails'
gem "browser"
gem 'groupdate'
gem "chartkick"
gem 'searchkick'
gem 'typhoeus'



#IMAGES
gem 'carrierwave', '~> 0.10.0'
gem 'mini_magick', '~> 4.3'

gem 'json'

gem 'rest-client'
gem 'file-utils'

#background processing libraries
gem 'daemons'
gem 'js-routes'

gem 'rails_autolink'

gem 'lograge'
gem 'bootstrap_form'

gem 'scout_apm'

gem 'sdoc',         #'0.4.0', 

group: :doc

gem 'will_paginate'#,           '3.0.7'
gem 'bootstrap-will_paginate'#, '0.0.10'

group :development, :test do
 # gem 'sqlite3'#,     '1.3.9'
  
  gem 'byebug'#,      '3.4.0'
  gem 'web-console'#, '2.0.0.beta3' #TODO What is this gem for? Do I need it?
  gem 'spring'#,      '1.1.3'
  gem 'letter_opener'
end

group :test do
  gem 'minitest-reporters'#, '1.0.5'
  gem 'mini_backtrace'#,     '0.1.3'
  gem 'guard-minitest',     '2.3.1' #this one breaks if I don't specify the version number
end

group :production do
  gem 'rails_12factor'
  gem 'puma'#,           '2.11.1' #railstutorial.org chapter 7: setting up a webserver
  
end

group :development do
 # gem 'quiet_assets'
  gem 'derailed'
  gem 'derailed_benchmarks'
  gem 'stackprof'
end