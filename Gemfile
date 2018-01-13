source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'pg_search'

# Assets
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'

# API
gem 'active_model_serializers'

# Faraday
gem 'faraday'
gem 'faraday_middleware'
gem 'link_header'

# Publish Admin
gem 'devise'
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'activeadmin_pagedown'
gem 'redcarpet'
gem 'paper_trail'

# Logging
gem 'lograge'
gem 'logstash-event'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'govuk-lint'
  gem 'launchy'
  gem 'rspec-rails'
end

group :development do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'rails-controller-testing'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

