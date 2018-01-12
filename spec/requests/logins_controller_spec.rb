require 'rails_helper'
require 'capybara/rails'
require "#{Rails.root}/lib/saltedge"

describe 'LoginsController', type: :request do
  context 'Public access to logins' do
    it 'denies access to logins#index' do
      get logins_path
      expect(response).to redirect_to new_user_session_url
    end
  end

  context 'Signed user access to logins' do
    def login_user
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    def create_customer
      SpectreApi.create_customer(@user)
    end
    before(:all) do
      login_user
      create_customer
    end

    after(:all) do
      delete_customer
    end

    def delete_customer
      SpectreApi.destroy_customer(@user.customer) if @user.customer
    end

    def logins_update
      get logins_path, params: { refresh: true }
    end

    def login_create
      post logins_path
      Capybara.app_host = 'https://www.saltedge.com'
      url = "/#{response.location.split('/')[3]}"
      visit url
      field = find('#providers-search')
      field.send_keys('Fake Bank Simple')
      sleep 1
      field.send_keys(:down, :enter)
      sleep 1
      input_password = find("input[name='password']")
      input_login = find("input[name='login']")
      button = find('input[value="Connect"]')

      input_login.send_keys('username')
      input_password.send_keys('secret')
      button.click
      sleep 20
    end

    def login_delete
      delete login_path(Login.last.id)
    end

    it 'can create new login', js: true do
      login_create
      expect { logins_update }.to change(Login, :count).by(1)
    end

    it 'can access to logins#destroy' do
      sign_in @user
      logins_update
      expect { login_delete }.to change(Login, :count).by(-1)
    end

    it 'can access to logins#index' do
      sign_in @user
      get logins_path
      expect(response).to render_template(:index)
    end
  end
end
