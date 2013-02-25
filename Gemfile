source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'haml', '3.1.7'
gem 'haml-rails', '0.3.5'
gem 'devise', '2.2.2'
gem 'jquery-rails', '2.2.1'

gem "thin", "1.5.0"
gem 'doorkeeper', '~> 0.6.7'
gem "rabl", "~> 0.7.9"
gem "backbone-on-rails", "~> 0.9.10.0"
#gem "anjlab-bootstrap-rails", ">=2.3", :require => 'bootstrap-rails', :git => 'git://github.com/anjlab/bootstrap-rails.git'
#gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :git => 'git://github.com/anjlab/bootstrap-rails.git', :branch => 'v2.2.2.x'
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails',
    :git => 'git://github.com/anjlab/bootstrap-rails.git'
gem "gon", "~> 4.0.2"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~>3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem "execjs", "1.4.0"	
  gem "therubyracer", "0.11.3"
  gem 'uglifier', '1.3.0'
  gem "haml_coffee_assets", "~> 1.11.0"
end

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'json_spec', '1.1.0'
  gem "rspec-rails", "2.12.2"
  gem 'guard-rspec', '2.4.0'
  gem 'guard-spork', '1.4.1'
  gem 'spork', '0.9.2'
end

group :test do
  gem "shoulda-matchers", "~> 1.4.2"
  gem 'capybara', '2.0.2'
  gem 'factory_girl_rails', '4.1.0'
  gem 'rb-fsevent', '0.9.3', require: false
  gem 'rb-inotify', '~>0.9.0'
  gem 'growl', '1.0.3'
  gem "listen", "0.7.2"
end

group :production do
  gem 'pg', '0.14.1'
end
