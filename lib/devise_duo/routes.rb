module ActionDispatch::Routing
  class Mapper
    protected

    def devise_duo(mapping, controllers)
      match "/#{mapping.path_names[:verify_duo]}", :controller => controllers[:devise_duo], :action => :GET_verify_duo, :as => :verify_duo, :via => :get
      match "/#{mapping.path_names[:verify_duo]}", :controller => controllers[:devise_duo], :action => :POST_verify_duo, :as => nil, :via => :post

      match "/#{mapping.path_names[:enable_duo]}", :controller => controllers[:devise_duo], :action => :GET_enable_duo, :as => :enable_duo, :via => :get
      match "/#{mapping.path_names[:enable_duo]}", :controller => controllers[:devise_duo], :action => :POST_enable_duo, :as => nil, :via => :post

      match "/#{mapping.path_names[:disable_duo]}", :controller => controllers[:devise_duo], :action => :POST_disable_duo, :as => :disable_duo, :via => :post

      match "/#{mapping.path_names[:verify_duo_installation]}", :controller => controllers[:devise_duo], :action => :GET_verify_duo_installation, :as => :verify_duo_installation, :via => :get
      match "/#{mapping.path_names[:verify_duo_installation]}", :controller => controllers[:devise_duo], :action => :POST_verify_duo_installation, :as => nil, :via => :post


      match "/request-sms", :controller => controllers[:devise_duo], :action => :request_sms, :as => :request_sms, :via => :post
    end
  end
end

