source 'https://rubygems.org'

ruby '2.5.1'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano-rbenv', '~> 2.1'
  gem 'capistrano3-puma'
end

gem "slack-notifier"
gem 'exception_notification'
gem 'nokogiri'
gem 'dotenv-rails', groups: [:development, :test]
gem 'sidekiq'
gem 'whenever', require: false
gem 'fast_jsonapi'
gem 'rack-cors'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
