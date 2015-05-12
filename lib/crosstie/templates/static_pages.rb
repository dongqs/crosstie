# static pages
generate "controller", "static_pages", "home", "status", "console"

inject_into_file "app/controllers/static_pages_controller.rb", after: "class StaticPagesController < ApplicationController\n" do
<<-EOF
  skip_before_action :authenticate_user!, only: [:home, :status]
  skip_before_action :authenticate_normal!, only: [:home, :status]
  before_action :authenticate_system!, only: [:console]
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
gsub_file "config/routes.rb", "get 'static_pages/console'", "get '/console' => 'static_pages#console'"

inject_into_file "spec/controllers/static_pages_controller_spec.rb", after: "RSpec.describe StaticPagesController, type: :controller do\n" do
<<-EOF

  before { sign_in_user }
EOF
end

create_file "spec/routing/static_pages_spec.rb", <<-EOF
require "rails_helper"

describe StaticPagesController, :type => :routing do
  describe "routing" do

    it "routes to #home" do
      expect(:get => "/").to route_to("static_pages#home")
    end

    it "routes to #status" do
      expect(:get => "/status").to route_to("static_pages#status")
    end

    it "routes to #console" do
      expect(:get => "/console").to route_to("static_pages#console")
    end
  end
end
EOF

append_file "app/views/static_pages/console.html.slim", <<-EOF
= console
EOF
