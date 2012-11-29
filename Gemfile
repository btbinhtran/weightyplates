source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'haml', '3.1.7'
gem 'haml-rails', '0.3.5'
gem 'rails-backbone', '0.8.0'
gem 'devise', '2.1.2'
gem 'jquery-rails', '2.1.4'
gem "marionette-rails", "~> 0.10.2"
gem "haml_coffee_assets", "~> 1.7.2"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~>3.2.3'
  gem 'coffee-rails', '3.2.1'
  gem "execjs", "1.4.0"	
  gem "therubyracer", "0.10.2"
  gem 'uglifier', '1.0.3'
end

group :development, :test do
  gem 'sqlite3', '1.3.6'
  gem 'json_spec', '1.1.0'
  gem "rspec-rails", "2.12.0"
  gem 'guard-rspec', '2.2.1'
  gem 'guard-spork', '1.2.3'
  gem 'spork', '0.9.2'
end

group :test do
  gem 'capybara', '2.0.1'
  gem 'factory_girl_rails', '4.1.0'
  gem 'rb-fsevent', '0.9.2', require: false
  gem 'rb-inotify', '0.8.8', require: false
  gem 'growl', '1.0.3'
end

group :production do
  gem 'pg', '0.14.1'
end
