source 'https://rubygems.org'

group :production do
  gem 'dalli'
  gem 'unicorn'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'debugger'
  gem 'thin'
  gem "minitest-rails"
end

ruby '2.1.1'
gem 'rails'
gem 'pg'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'

# API endpoints, presenter and documentation
gem 'grape'
gem "grape-entity"
gem 'grape-swagger'
gem "devise", "~> 3.0.0.rc" 
