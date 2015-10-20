module DeviseDuo
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseDuo::Controllers::Helpers
    end
    ActiveSupport.on_load(:action_view) do
      include DeviseDuo::Views::Helpers
    end

    # extend mapping with after_initialize because it's not reloaded
    config.after_initialize do
      Devise::Mapping.send :include, DeviseDuo::Mapping
    end
  end
end

