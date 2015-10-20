# Notice!!!

This was shamelessly copied from [authy-devise](https://github.com/authy/authy-devise) and adapted for use with Duo Security. Big ups to Authy for their fantastic gem!

# Duo Devise

This is a [Devise](https://github.com/plataformatec/devise) extension to add Two-Factor Authentication with Duo Security to your rails application.


## Pre-requisites

Get Duo Security app keys: [https://www.duosecurity.com](https://www.duosecurity.com)


## Getting started

First create an initializer in `config/initializers/duo.rb`

```ruby
# get these from the duo portal
DeviseDuo.integration_key = ''
DeviseDuo.secret_key = ''
DeviseDuo.api_hostname = ''
# generate this with rake secret
DeviseDuo.application_secret_key = ''
```

Next add the gem to your Gemfile:

```ruby
gem 'devise'
gem 'devise_duo'
```

And then run `bundle install`

Add `Devise Duo` to your App:

    rails g devise_duo:install

    --haml: Generate the views in Haml
    --sass: Generate the stylesheets in Sass

### Configuring Models

Configure your Devise user model:

    rails g devise_duo [MODEL_NAME]

or add the following line to your `User` model

```ruby
devise :duo_authenticatable, :database_authenticatable
```

Change the default routes to point to something sane like:

```ruby
devise_for :users, :path_names => {
	:verify_duo => "/verify-token",
	:enable_duo => "/enable-two-factor",
	:verify_duo_installation => "/verify-installation"
}
```

Then run the migrations:

    rake db:migrate

Now whenever a user wants to enable two-factor authentication they can go
to:

    http://your-app/users/enable-two-factor

And when the user log's in he will be redirected to:

    http://your-app/users/verify-token


## Custom Views

If you want to customise your views, you can modify the files that are located at:

    app/views/devise/devise_duo/enable_duo.html.erb
    app/views/devise/devise_duo/verify_duo.html.erb
    app/views/devise/devise_duo/verify_duo_installation.html.erb


## Custom Redirect Paths (eg. using modules)

If you want to customise the redirects you can override them within your own controller like this:

```ruby
class MyCustomModule::DeviseDuoController < Devise::DeviseDuoController

  protected
    def after_duo_enabled_path_for(resource)
      my_own_path
    end

    def after_duo_verified_path_for(resource)
      my_own_path
    end

    def invalid_resource_path
      my_own_path
    end
end
```

And tell the router to use this controller

```ruby
devise_for :users, controllers: {devise_duo: 'my_custom_module/devise_duo'}
```


## I18n

The install generator also copy a `Devise Duo` i18n file which you can find at:

    config/locales/devise.duo.en.yml


## Running Tests

To prepare the tests run the following commands:
```bash
$ cd spec/rails-app
$ bundle install
$ RAILS_ENV=test bundle exec rake db:migrate
```

Now on the project root run the following commands:
```bash
$ bundle exec rspec spec/
```

## Copyright

Copyright (c) 2014 Authy Inc. See LICENSE.txt for
further details.
