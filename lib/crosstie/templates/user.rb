# user.rb
inject_into_file "app/models/user.rb", before: 'end' do
<<-EOF

  # crosstie skeleton

  # ldap

  # grant roles

  # grant normal

  # username

  # authentication_token

  # authorization

EOF
end

# grant roles for the first user
inject_into_file "app/models/user.rb", after: "# grant roles\n" do
<<-EOF
  after_create :grant_roles, if: Proc.new {
    !Rails.env.test? && User.count == 1
  }

  def grant_roles
    Role::USER_ROLES.each do |role|
      self.grant role
    end
  end
EOF
end

# grant normal role for signed up users
inject_into_file "app/models/user.rb", after: "# grant normal\n" do
<<-EOF
  after_create :grant_normal, if: Proc.new {
    ENV['GRANT_NORMAL']
  }

  def grant_normal
    self.grant :normal
  end
EOF
end

append_file "config/application.yml", <<-EOF
#GRANT_NORMAL: true
EOF
run "cp config/application.yml config/application.yml.example"


# add username to users
inject_into_file "app/models/user.rb", after: "# username\n" do
<<-EOF
  alias_attribute :name, :username
EOF
end

generate "migration", "add_username_to_users", "username:string:index"
rake "db:migrate"

gsub_file "app/views/devise/sessions/new.html.erb", ":email", ":username"
gsub_file "app/views/devise/sessions/new.html.erb", "email_field", "text_field"

[
  "app/views/devise/registrations/new.html.erb",
  "app/views/devise/registrations/edit.html.erb",
].each do |file|
  inject_into_file file, after: "<%= devise_error_messages! %>\n" do
<<-EOF
    <div class="form-group">
      <%= f.label :username %>
      <%= f.text_field :username, class: 'form-control' %>
    </div>
EOF
  end
end

gsub_file "config/initializers/devise.rb", "# config.authentication_keys = [ :email ]", "config.authentication_keys = [ :username ]"
