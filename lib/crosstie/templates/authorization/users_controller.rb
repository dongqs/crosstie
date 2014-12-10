class UsersController < ApplicationController

  skip_before_action :authenticate_normal!, only: [:index, :role]
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

    raise "role operation #{operation} undefined" unless operation.to_sym.in? Role::OPERATIONS
    raise "user role #{role} undefined" unless role.to_sym.in? Role::USER_ROLES
    raise "current user not in charge of #{role}" unless role.to_sym.in? current_user.managing_roles
    @user.send operation, role
    redirect_back :root, notice: "User #{@user.name} was #{operation}ed role #{role}"
  rescue => exc
    redirect_back :root, notice: exc.to_s
  end
end
