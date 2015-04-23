# static pages
generate "controller", "static_pages", "home", "status"
inject_into_file "app/controllers/static_pages_controller.rb", after: "class StaticPagesController < ApplicationController\n" do
<<-EOF
  skip_before_action :authenticate_user!, only: [:home, :status]
  skip_before_action :authenticate_normal!, only: [:home, :status]
EOF
end
inject_into_file "app/controllers/static_pages_controller.rb", after: "def status\n" do
<<-EOF
    render json: {
      status: "ok",
      hostname: Socket.gethostname,
      service: "#{app_path}",
      commit: @@comment ||= `git log -1 --oneline`
    }
EOF
end
gsub_file "config/routes.rb", "get 'static_pages/home'", "root to: 'static_pages#home'"
gsub_file "config/routes.rb", "get 'static_pages/status'", "get '/status' => 'static_pages#status'"
inject_into_file "spec/controllers/static_pages_controller_spec.rb", after: "RSpec.describe StaticPagesController, type: :controller do\n" do
<<-EOF

  before { sign_in_user }
EOF
end
