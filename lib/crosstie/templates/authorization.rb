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
  read_template "authorization/application_controller.rb"
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
  read_template "authorization/users.rb"
end

create_file "app/controllers/users_controller.rb",
            read_template("authorization/users_controller.rb")

create_file "spec/controllers/users_controller_spec.rb",
            read_template("authorization/users_controller_spec.rb")

create_file "app/views/users/index.html.slim",
            read_template("authorization/index.html.slim")
