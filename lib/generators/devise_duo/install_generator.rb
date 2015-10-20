module DeviseDuo
  module Generators
    # Install Generator
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      class_option :haml, :type => :boolean, :required => false, :default => false, :desc => "Generate views in Haml"
      class_option :sass, :type => :boolean, :required => false, :default => false, :desc => "Generate stylesheet in Sass"

      desc "Install the devise duo extension"

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise.duo.en.yml"
      end

      def copy_views
        if options.haml?
          copy_file '../../../app/views/devise/enable_duo.html.haml', 'app/views/devise/devise_duo/enable_duo.html.haml'
          copy_file '../../../app/views/devise/verify_duo.html.haml', 'app/views/devise/devise_duo/verify_duo.html.haml'
        else
          copy_file '../../../app/views/devise/enable_duo.html.erb', 'app/views/devise/devise_duo/enable_duo.html.erb'
          copy_file '../../../app/views/devise/verify_duo.html.erb', 'app/views/devise/devise_duo/verify_duo.html.erb'
        end
      end

    end
  end
end
