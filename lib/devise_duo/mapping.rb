module DeviseDuo
  module Mapping
    def self.included(base)
      base.alias_method_chain :default_controllers, :duo_authenticatable
    end

    private
    def default_controllers_with_duo_authenticatable(options)
      options[:controllers] ||= {}
      options[:controllers][:passwords] ||= "devise_duo/passwords"
      default_controllers_without_duo_authenticatable(options)
    end
  end
end