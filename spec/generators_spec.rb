require 'spec_helper'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'rails/generators'
require 'generators/devise_duo/devise_duo_generator'

describe "generators for devise_duo" do
  RAILS_APP_PATH = File.expand_path("../rails-app", __FILE__)

  def rails_command(*args)
    `cd #{RAILS_APP_PATH} && BUNDLE_GEMFILE=#{RAILS_APP_PATH}/Gemfile bundle exec rails #{args.join(" ")}`
  end

  it "rails g should include the generators" do
    @output = rails_command("g")
    @output.include?('devise_duo:install').should be_true
    @output.include?('active_record:devise_duo').should be_true
  end

  it "rails g devise_duo:install" do
    @output = rails_command("g", "devise_duo:install", "-s")
    @output.include?('config/initializers/devise.rb').should be_true
    @output.include?('config/locales/devise.duo.en.yml').should be_true
    @output.include?('app/views/devise/devise_duo/enable_duo.html.erb').should be_true
    @output.include?('app/views/devise/devise_duo/verify_duo.html.erb').should be_true
  end
end
