# application_controller.rb
inject_into_file "app/controllers/application_controller.rb", before: 'end' do
<<-EOF

  # controller_helpers

  # authentication_token

  # authorization

EOF
end

# application.rb
inject_into_file "config/application.rb", after: "class Application < Rails::Application\n" do
<<-EOF

    # timezone

    # scaffold

    # active_job

EOF
end

# routes.rb
inject_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
<<-EOF

  # active_job

EOF
end
