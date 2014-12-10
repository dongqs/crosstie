inject_into_file "app/models/user.rb", after: "# authorization\n" do
<<-EOF

  def managing_roles
    roles = []
    roles += [:system, :admin] if has_role? :system
    roles += [:normal] if has_role? :admin
    roles.uniq
  end
EOF
end

inject_into_file "app/controllers/application_controller.rb", after: "# authorization\n" do
<<-EOF

  before_action :authenticate_normal!

  class AuthenticationError < SecurityError; end
  class AuthorizationError < SecurityError; end

  rescue_from AuthenticationError do |exception|
    flash[:error] = exception.to_s
    redirect_to :root
  end

  rescue_from AuthorizationError do |exception|
    flash[:error] = exception.to_s
    redirect_to :root
  end

  def authenticate_current_user! user
    raise AuthorizationError unless current_user == user or current_user.system?
  end

  def authenticate_role! role, resource = nil
    return unless user_signed_in?
    unless current_user.has_role? role
      raise AuthenticationError, "\#{current_user.name} not authenticated as a \#{role} user"
    end
  end

  def authenticate_any_role! *roles
    return unless user_signed_in?
    unless current_user.has_any_role? *roles
      raise AuthenticationError, "\#{current_user.name} not authenticated as any of \#{roles.join(", ")}"
    end
  end

  Role::USER_ROLES.each do |role|
    define_method "authenticate_\#{role.to_s}!" do
      authenticate_role! role
    end
  end
EOF
end

inject_into_file "app/models/role.rb", after: "scopify\n" do
<<-EOF
  OPERATIONS = [:grant, :revoke]
  USER_ROLES = [:system, :admin, :normal]
EOF
end
gsub_file "spec/support/devise.rb", "role = :user", "role = :system", force: true
inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
<<-EOF
  resources :users, only: [:index] do
    member do
      put :role
    end
  end
EOF
end
inject_into_file "spec/factories/users.rb", after: "factory :user do\n" do
<<-EOF
    factory :normal do
      after(:create) do |user|
        user.grant :normal
      end
    end

    factory :admin do
      after(:create) do |user|
        user.grant :normal
        user.grant :admin
      end
    end

    factory :system do
      after(:create) do |user|
        user.grant :normal
        user.grant :system
      end
    end
EOF
end
create_file "app/controllers/users_controller.rb", <<-EOF
class UsersController < ApplicationController

  skip_before_action :authenticate_admin!, only: [:index, :role]

  def index
    authenticate_any_role! :system, :admin
    @users = User.all
    @roles = current_user.managing_roles
  end

  def role
    authenticate_any_role! :system, :admin
    @user = User.find params[:id]
    operation, role = params[:operation].to_sym, params[:role].to_sym

    raise "role operation \#{operation} undefined" unless operation.to_sym.in? Role::OPERATIONS
    raise "user role \#{role} undefined" unless role.to_sym.in? Role::USER_ROLES
    raise "current user not in charge of \#{role}" unless role.to_sym.in? current_user.managing_roles
    @user.send operation, role
    redirect_back :root, notice: "User \#{@user.name} was \#{operation}ed role \#{role}"
  rescue => exc
    redirect_back :root, notice: exc.to_s
  end
end
EOF
create_file "spec/controllers/users_controller_spec.rb", <<-EOF
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
EOF
create_file "app/views/users/index.html.slim", <<-EOF
table.table
  tr
    th Username
    - @roles.each do |role|
      th = role.to_s.titleize
    end
  - @users.each do |user|
    tr
      td = user.username
      - @roles.each do |role|
        td
          = form_for user, url: role_user_path(user), method: :put do |f|
              - operation, activation, btn_class = user.has_role?(role) ? \
                %w(revoke active btn-success) : %w(grant inactive btn-danger)
              = hidden_field_tag :operation, operation
              = hidden_field_tag :role, role
              = f.submit activation, class: "btn \#{btn_class}"
EOF
