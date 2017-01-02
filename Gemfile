ruby '2.2.5'

source 'https://rubygems.org'

# Environment
gem 'dotenv-rails', groups: [:development, :test]

# Rails
gem 'rails', '4.2.5'

# Database
gem 'pg', '~> 0.15'

# Server
gem 'puma'

# Worker
gem 'sidekiq'
gem 'clockwork'

# HTTP
gem 'faraday', '~> 0.9.1'
gem 'faraday_middleware'

# User Accounts
gem 'devise'
gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

# Trevor Content
#gem 'sir_trevor_rails'

# User Interface
gem 'font-awesome-rails'
gem 'bootstrap-sass'
gem 'bootstrap-datepicker-rails'
gem 'svg-flags-rails'
gem 'lightbox-bootstrap-rails'

# Asssets
gem 'jquery-rails'
gem 'coffee-rails', '>= 4.0.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier'

# Caching
gem 'redis-rails'

# Image Hosting
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

# ActiveRecord Utilities
gem 'date_validator'
gem 'phony_rails'
gem 'email_validator'
gem 'enum_help'
gem 'auto_strip_attributes'

# Pagination
gem 'will_paginate-bootstrap'

# Forms
gem 'simple_form'
gem 'country_select'

# URLs
gem 'friendly_id', '~> 5.1.0'

# Email
#gem 'roadie-rails'

# Money & Payments
#gem 'stripe-rails'
#gem 'stripe_event'
#gem 'money-rails'

# Third Parties
#gem 'intercom-rails'
#gem 'mailchimp-api', require: 'mailchimp'

# Utility
#gem 'full-name-splitter'
#gem 'countries', require: 'countries/global'

# Errors
gem 'airbrake'

# Forms
#gem 'rightsignature', '~> 1.0.0'

# Groups
group :development, :test do
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'pry-rails'
end

group :development do
  gem 'bullet'
  gem 'jshint'
  gem 'annotate'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
#  gem 'stripe-ruby-mock', '~> 2.2.1', :require => 'stripe_mock'
end

group :staging, :production do
  gem 'rails_12factor'
end
