# authentication token

generate "migration", "add_authentication_token_to_users", "authentication_token:string:index"
rake "db:migrate"

inject_into_file "app/models/user.rb", after: "# authentication_token\n" do
<<-EOF
  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
EOF
end

inject_into_file "app/controllers/application_controller.rb", after: "# authentication_token\n" do
<<-EOF
  before_action :authenticate_user_from_token!

  def authenticate_user_from_token!
    auth_token = params[:auth_token].presence
    user       = auth_token && User.find_by_authentication_token(auth_token.to_s)

    if user
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end
EOF
end

inject_into_file "app/views/devise/registrations/edit.html.erb", before: "    <%= f.submit 'Update', :class => 'button right' %>" do
<<-EOF
    <fieldset>
      <div class="form-group">
        <%= f.label :authentication_token %>
        <%= f.text_field :authentication_token, class: 'form-control', disabled: true %>
      </div>
    </fieldset>
EOF
end
