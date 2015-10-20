require 'spec_helper'

describe "routes for devise_duo" do
  it "route to devise_duo#GET_verify_duo" do
    get('/users/verify_duo').should route_to("devise/devise_duo#GET_verify_duo")
  end

  it "routes to devise_duo#POST_verify_duo" do
    post('/users/verify_duo').should route_to("devise/devise_duo#POST_verify_duo")
  end

  it "routes to devise_duo#GET_enable_duo" do
    get('/users/enable_duo').should route_to("devise/devise_duo#GET_enable_duo")
  end

  it "routes to devise_duo#POST_enable_duo" do
    post('/users/enable_duo').should route_to("devise/devise_duo#POST_enable_duo")
  end

end
