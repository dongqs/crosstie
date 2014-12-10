
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
      raise AuthenticationError, "#{current_user.name} not authenticated as a #{role} user"
    end
  end

  def authenticate_any_role! *roles
    return unless user_signed_in?
    unless current_user.has_any_role? *roles
      raise AuthenticationError, "#{current_user.name} not authenticated as any of #{roles.join(", ")}"
    end
  end

  Role::USER_ROLES.each do |role|
    define_method "authenticate_#{role.to_s}!" do
      authenticate_role! role
    end
  end
