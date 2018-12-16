source 'https://rubygems.org'
ruby '2.3.5'

gem 'rails', '~> 4.0.3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'devise'
gem 'rolify'
gem 'figaro'
gem 'pry'
gem 'prawn'
gem 'jquery-turbolinks'
gem 'will_paginate', '~> 3.0.6'
gem 'jquery-tablesorter'

group :production do
  gem 'pg', '0.17.1' # TODO: fixed in Rails 5.1.5
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails', '2.14.2'
  gem 'test-unit'
  gem 'sqlite3'
end

group :test do
    gem 'database_cleaner', '~> 1.3.0'
    gem 'capybara', '2.2.1'
    gem 'selenium-webdriver'
    gem 'shoulda-matchers'
    gem 'factory_girl_rails', '~> 4.0'
    gem 'simplecov', '~> 0.9.0', :require => false
    gem 'webmock'
    gem 'launchy'
end

group :doc do
  gem 'sdoc', require: false
end
