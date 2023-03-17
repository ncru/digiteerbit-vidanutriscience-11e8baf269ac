source 'https://rubygems.org'

# Declare the ruby version for heroku.
ruby '2.6.6'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.0.4'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Use FontAwesome Sass.
gem 'font-awesome-sass', '~> 5.9.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use paperclip for file uploads
gem 'paperclip', '~> 4.1'
# Use slim-rails for templating
gem 'slim-rails'
# Use devise for authentication and session
gem 'devise'
# Use cocoon for nested forms
gem 'cocoon'
# For Amazon Syncs
gem 'aws-sdk', '1.63.0'
gem 'asset_sync'
gem 'fog-aws'
gem 's3_direct_upload'
# Use will_paginate for pagination
gem 'will_paginate'
gem 'newrelic_rpm'
gem 'activerecord-import'
gem "rack-timeout", require:"rack/timeout/base"

group :production do
  gem 'therubyracer'
  gem 'rails_12factor'
  gem 'heroku-deflater'
  # Use Puma as the app server
  gem 'puma', '~> 3.0'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors'
  gem 'rack-mini-profiler'
  gem 'binding_of_caller'
  gem 'bcrypt-ruby', '3.1.0', :require => 'bcrypt'
end

gem 'switchery-rails'
gem 'instagram', '~> 1.1.5'
gem 'tzinfo'
gem 'tzinfo-data'
gem 'sendgrid-ruby'
gem 'omniauth-facebook'
gem 'social-share-button'
gem 'activemerchant' # for paypal
gem 'httparty'
