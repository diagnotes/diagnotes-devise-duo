require 'devise_duo/hooks/duo_authenticatable'
module Devise
  module Models
    module DuoAuthenticatable
      extend ActiveSupport::Concern

      def with_duo_authentication?(request)
        self.duo_enabled
      end

    end
  end
end

