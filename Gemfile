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

# API endpoints, presenter and documentation
gem 'grape'
gem "grape-entity"
gem 'grape-swagger'
