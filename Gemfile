source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem 'rails', '>= 6.1.1'
# Use sqlite3 as the database for Active Record
# gem "sqlite3"
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "3.2.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
# gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use ActiveStorage variant
gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  # gem "capybara", ">= 2.15", "< 4.0"
  gem 'capybara', '>= 2.15'
  gem "selenium-webdriver"
  gem "webdrivers" # brew の chromedriver ではなく最新のものを自動的に ~/.webdrivers/chromedriver に取得し Capybara はそちらを使うようになる
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ################################################################################

group :development, :test do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring-commands-rspec"

  gem "capistrano"
  gem "capistrano-rails"        # capistrano + capistrano-bundler
  gem "capistrano-passenger"
  gem "capistrano-rbenv"
  gem "capistrano-yarn"
  gem "capistrano-rails-console"
  gem "capistrano-maintenance", require: false
  gem "slackistrano"            # for cap production slack:deploy:test

  gem "rspec-rails"
  gem "rails-controller-testing" # controller で assigns を使うため
  gem "rspec-power_assert"
  gem "factory_bot_rails"

  gem "test-prof"               # for let_it_be
end

group :development do
  gem "foreman", require: false
  gem "annotate_models"
end

group :test do
  gem "database_cleaner"
end

group :development, :test do
  gem "timecop"
end

gem "slim-rails"

gem "rails_autolink"
gem "kaminari"

gem "memory_record"
gem "tree_support"
gem "table_format"
gem "html_format"

gem "acts_as_list"

group :development do
  gem "aam"
end

# gem "bioshogi", path: "~/src/bioshogi"
gem "bioshogi", github: "akicho8/bioshogi"
gem "rmagick"                   # for Bioshogi to_img method (mini-magickに変更したい)

gem "nokogiri" # for Swars::Agent

gem "faraday"                   # 主に「なんでも棋譜変換」用
gem "faraday_middleware"        # リダイレクト先おっかけ機能付与

gem "acts-as-taggable-on"

gem "rubyzip", require: "zip" # KIF一括ダウンロード用

gem "whenever", require: false

gem "codecov", require: false, group: :test

gem "rack-cors", require: "rack/cors" # 別のドメインからJSONアクセスできるようにするための何か

# application 用
gem "slack-ruby-client"

# エラー通知
gem "exception_notification"
gem "slack-notifier"

# devise
gem "devise"
gem "devise-i18n"
gem "devise-i18n-views"
gem "bcrypt"

# omniauth
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-twitter"
gem "omniauth-github"

# 音声読み上げ
gem "aws-sdk-polly"

# Palette
gem "color"

# BOT判定用
gem "rack-user_agent"

# 休日判定
gem "holiday_jp"

# Rails Cache
# たいして速くないのとCのビルドしたのがロードされないので使わない
# gem "hiredis"

# ActiveJob
gem 'sidekiq'
gem 'redis-namespace'

gem "puma_worker_killer"
