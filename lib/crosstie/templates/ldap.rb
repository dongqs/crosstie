# devise_ldap_authenticatable"

generate "devise_ldap_authenticatable:install"
run "cp config/ldap.yml config/ldap.yml.bak"

gsub_file "app/models/user.rb", "  devise :ldap_authenticatable, :registerable,", ""
gsub_file "app/models/user.rb", "         :recoverable, :rememberable, :trackable, :validatable", ""

inject_into_file "app/models/user.rb", after: "# ldap\n" do
<<-EOF

  unless Rails.env.production?
    devise :database_authenticatable, :rememberable, :trackable, :registerable# , :recoverable, :validatable
  else
    devise :ldap_authenticatable, :rememberable, :trackable, :registerable# , :recoverable, :validatable

    before_validation :get_ldap_email, :get_ldap_id

    def get_ldap_email
      self.email = Devise::LDAP::Adapter.get_ldap_param(self.username,"mail").first
    end

    def get_ldap_id
      self.id = Devise::LDAP::Adapter.get_ldap_param(self.username,"uidnumber").first
    end

    # hack for remember_token
    def authenticatable_salt
      Digest::SHA1.hexdigest(email)[0,29]
    end
  end
EOF
end

inject_into_file "config/initializers/devise.rb", after: "# ==> LDAP Configuration \n" do
<<-EOF
  config.ldap_logger = true
  config.ldap_create_user = true
  config.ldap_update_password = true
  config.ldap_use_admin_to_bind = true
EOF
end
