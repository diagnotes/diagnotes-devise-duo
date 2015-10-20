module DeviseDuo
  module Views
    module Helpers

      def enable_duo_form(&block)
        form_tag([resource_name, :enable_duo], :class => 'duo-form', :method => :post) do
          capture(&block)
        end
      end

    end
  end
end

