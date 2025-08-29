source "https://rubygems.org"

gem "vite_rails", "~> 3.0"
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "factory_bot_rails"
  gem "dotenv", ">= 3.0"
  gem "rspec-rails"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "letter_opener"
  gem "web-console"
end

group :test do
  gem "shoulda-matchers"
  gem "capybara-lockstep", require: false
  gem "selenium-webdriver", require: false
  gem "capybara", require: false
end

gem "devise", "~> 4.9"
