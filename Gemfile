source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
gem 'bcrypt',         '3.1.12'
gem 'faker',          '1.7.3'
gem 'carrierwave',             '1.2.2'
gem 'mini_magick',             '4.7.0'
gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'bootstrap-sass', '3.3.7'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.6.0'
# Use Puma as the app server
gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'
gem "railroady"
gem "simplecov"
gem 'whenever', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
end

group :development do
  gem 'web-console',           '3.5.1'
	gem 'listen',                '3.1.5'
	gem 'spring',                '2.0.2'
	gem 'spring-watcher-listen', '2.0.1'
end

group :production do
  gem 'pg', '0.20.0'
  gem 'fog', '1.42'
	end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
