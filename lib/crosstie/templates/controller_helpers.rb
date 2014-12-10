inject_into_file "app/controllers/application_controller.rb", after: "# controller_helpers\n" do
<<-EOF
  skip_before_action :verify_authenticity_token, if: :skip_authenticity?
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :log_current_user

  def log_current_user
    logger.info "Current user: \#{current_user.email}" if current_user
  end

  def redirect_back default_path = :root, options = {}
    redirect_to :back, options
  rescue ActionController::RedirectBackError
    redirect_to default_path, options
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :email
  end

  def skip_authenticity?
    request.format.json? or params[:skip_authenticity]
  end
EOF
end
