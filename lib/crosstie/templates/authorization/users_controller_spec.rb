require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  let(:valid_session) { { } }

  describe "GET index" do
    it "redirect normal users" do
      @user = sign_in_user :normal
      get :index, {}, valid_session
      expect(response).to redirect_to :root
    end

    it "assigns all users as @users" do
      @user = sign_in_user :admin
      get :index, {}, valid_session
      expect(assigns(:users)).to eq [@user]
      expect(assigns(:roles)).to eq [:normal]
    end

    it "assigns all users as @users" do
      @user = sign_in_user :system
      get :index, {}, valid_session
      expect(assigns(:users)).to eq [@user]
      expect(assigns(:roles)).to eq [:system, :admin]
    end
  end

  describe "PUT role" do

    describe "normal users" do

      it "redirect normal users" do
        sign_in_user :normal
        user = FactoryGirl.create :normal
        operation = :grant
        role = :normal
        put :role, {:id => user.to_param, :operation => operation, :role => role}, valid_session
        expect(response).to redirect_to(:root)
      end
    end

    describe "system users" do

      describe "global roles" do
        it "grant role to user" do
          sign_in_user :system
          user = FactoryGirl.create :system

          expect(user).to_not be_has_role :admin
          put :role, {:id => user.to_param, :operation => :grant, :role => :admin}, valid_session
          expect(assigns(:user)).to be_has_role :admin
        end

        it "revoke role from user" do
          sign_in_user :system
          user = FactoryGirl.create :user
          user.grant 'admin'

          expect(user).to be_has_role :admin
          put :role, {:id => user.to_param, :operation => :revoke, :role => :admin}, valid_session
          expect(assigns(:user)).to_not be_has_role :admin
        end
      end
    end
  end
end
