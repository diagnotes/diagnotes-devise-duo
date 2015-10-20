module DeviseDuo
  module Generators
    class DeviseDuoGenerator < Rails::Generators::NamedBase

      namespace "devise_duo"

      desc "Add :duo_authenticatable directive in the given model, plus accessors. Also generate migration for ActiveRecord"

      def inject_devise_duo_content
        path = File.join("app","models","#{file_path}.rb")
        if File.exists?(path) &&
          !File.read(path).include?("duo_authenticatable")
          inject_into_file(path,
                           "duo_authenticatable, :",
                           :after => "devise :")
        end

      end

      hook_for :orm

    end
  end
end
