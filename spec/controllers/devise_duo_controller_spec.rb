require 'spec_helper'

describe Devise::DeviseDuoController do
  include Devise::TestHelpers

  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @user = create_user
  end

  describe "GET #verify_duo" do
    it "Should render the second step of authentication" do
      request.session["user_id"] = @user.id
      request.session["user_password_checked"] = true
      get :GET_verify_duo
      response.should render_template('verify_duo')
    end

    it "Should no render the second step of authentication if first step is incomplete" do
      request.session["user_id"] = @user.id
      get :GET_verify_duo
      response.should redirect_to(root_url)
    end

    it "should redirect to root_url" do
      get :GET_verify_duo
      response.should redirect_to(root_url)
    end
  end

  describe "POST #verify_duo" do
    it "Should login the user if token is ok" do
      request.session["user_id"] = @user.id
      request.session["user_password_checked"] = true

      post :POST_verify_duo, :token => '0000000'
      @user.reload
      @user.last_sign_in_with_duo.should_not be_nil

      response.cookies["remember_device"].should be_nil
      response.should redirect_to(root_url)
      flash.now[:notice].should_not be_nil
    end

    it "Should set remember_device if selected" do
      request.session["user_id"] = @user.id
      request.session["user_password_checked"] = true

      post :POST_verify_duo, :token => '0000000', :remember_device => '1'
      @user.reload
      @user.last_sign_in_with_duo.should_not be_nil

      response.cookies["remember_device"].should_not be_nil
      response.should redirect_to(root_url)
      flash.now[:notice].should_not be_nil
    end

    it "Shouldn't login the user if token is invalid" do
      request.session["user_id"] = @user.id
      request.session["user_password_checked"] = true

      post :POST_verify_duo, :token => '5678900'
      response.should render_template('verify_duo')
    end

    context 'User is lockable' do

      let(:user) { create_lockable_user }

      before do
        controller.stub(:find_resource).and_return user
        controller.instance_variable_set :@resource, user
      end

      it 'locks the account when failed_attempts exceeds maximum' do
        request.session['user_id']               = user.id
        request.session['user_password_checked'] = true

        too_many_failed_attempts.times do
          post :POST_verify_duo, token: invalid_duo_token
        end

        user.reload
        expect(user.access_locked?).to be_true
      end

    end

    context 'User is not lockable' do

      it 'does not lock the account when failed_attempts exceeds maximum' do
        request.session['user_id']               = @user.id
        request.session['user_password_checked'] = true

        too_many_failed_attempts.times do
          post :POST_verify_duo, token: invalid_duo_token
        end

        @user.reload
        expect(@user.locked_at).to be_nil
      end

    end

  end

  describe "GET #enable_duo" do
    it "Should render enable duo view" do
      user2 = create_user
      sign_in user2
      get :GET_enable_duo
      response.should render_template('enable_duo')
    end

    it "Shouldn't render enable duo view" do
      get :GET_enable_duo
      response.should redirect_to(new_user_session_url)
    end

    it "should redirect if user has duo enabled" do
      @user.update_attribute(:duo_enabled, true)
      sign_in @user
      get :GET_enable_duo
      response.should redirect_to(root_url)
      flash.now[:notice].should == "Two factor authentication is already enabled."
    end

    it "Should render enable duo view if duo enabled is false" do
      sign_in @user
      get :GET_enable_duo
      response.should render_template('enable_duo')
    end
  end

  describe "POST #enable_duo" do
    it "Should create user in duo application" do
      user2 = create_user
      sign_in user2

      post :POST_enable_duo, :cellphone => '2222227', :country_code => '57'
      user2.reload
      user2.duo_enabled.should_not be_nil
      flash.now[:notice].should == "Two factor authentication was enabled"
      response.should redirect_to(user_verify_duo_installation_url)
    end

    it "Should not create user register user failed" do
      user2 = create_user
      sign_in user2

      post :POST_enable_duo, :cellphone => '22222', :country_code => "57"
      response.should render_template('enable_duo')
      flash[:error].should == "Something went wrong while enabling two factor authentication"
    end

    it "Should redirect if user isn't authenticated" do
      post :POST_enable_duo, :cellphone => '3010008090', :country_code => '57'
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "POST #disable_duo" do
    it "Should disable 2FA" do
      sign_in @user
      @user.update_attribute(:duo_enabled, true)

      post :POST_disable_duo
      @user.reload
      @user.duo_enabled.should be_false
      flash.now[:notice].should == "Two factor authentication was disabled"
      response.should redirect_to(root_url)
    end

    it "Should not disable 2FA" do
      sign_in @user
      @user.update_attribute(:duo_enabled, true)

      duo_response = mock('duo_response')
      duo_response.stub(:ok?).and_return(false)

      post :POST_disable_duo
      @user.reload
      @user.duo_enabled.should be_true
      flash[:error].should == "Something went wrong while disabling two factor authentication"
    end

    it "Should redirect if user isn't authenticated" do
      post :POST_disable_duo
      response.should redirect_to(new_user_session_url)
    end
  end
end
