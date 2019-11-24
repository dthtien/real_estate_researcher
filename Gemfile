source 'https://rubygems.org'

ruby '2.6.0'

gem 'rails', '6.0.0'
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
  gem 'scout_apm'
  gem 'rack-mini-profiler'
  gem 'memory_profiler'
  # For call-stack profiling flamegraphs
  gem 'flamegraph'
  gem 'stackprof'
end

gem "slack-notifier"
gem 'exception_notification'
gem 'nokogiri'
gem 'dotenv-rails', groups: [:development, :test]

gem 'sidekiq', '>= 5.0', '<= 5.9'
gem 'capistrano-sidekiq', group: :development

gem 'fast_jsonapi'
gem "rack-cors", ">= 1.0.4"
gem 'whenever', require: false
gem 'friendly_id', '~> 5.2.4'
gem 'kaminari'
gem "webpacker"
gem "sidekiq-cron", "~> 1.1"
gem "skylight"
gem "httparty"
gem 'rails_admin', '~> 2.0'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
