# devise
generate "devise:install"

# improve password strength
gsub_file "config/initializers/devise.rb", "config.password_length = 8..128", "config.password_length = 4..128"

# generate "devise:views" # taken over by rails_layout
generate "devise", "user"
rake "db:migrate"

prepend_file "spec/rails_helper.rb", <<-EOF
require 'simplecov'
SimpleCov.start
EOF

inject_into_file "spec/rails_helper.rb", after: "# Dir[Rails.root.join(\"spec/support/**/*.rb\")].each { |f| require f }\n" do
<<-EOF
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f } # since rspec 3.1
EOF
end

inject_into_file "spec/rails_helper.rb", after: "RSpec.configure do |config|\n" do
<<-EOF
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
EOF
end

create_file "spec/support/devise.rb", <<-EOF
module ValidUserControllerHelper
  def sign_in_user role = :user
    @user ||= FactoryGirl.create role
    sign_in :user, @user
    @user
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view
  config.include ValidUserControllerHelper, :type => :controller
  config.include ValidUserControllerHelper, :type => :view
end

# This support package contains modules for authenticaiting
# devise users for request specs.

# This module authenticates users for request specs.#
module ValidUserRequestHelper
    # Define a method which signs in as a valid user.
    def sign_in_user role = :user
        # ASk factory girl to generate a valid user for us.
        @user ||= FactoryGirl.create role

        # We action the login request using the parameters before we begin.
        # The login requests will match these to the user we just created in the factory, and authenticate us.
        post_via_redirect user_session_path, 'user[username]' => @user.username, 'user[password]' => @user.password
    end
end

# Configure these to modules as helpers in the appropriate tests.
RSpec.configure do |config|
    # Include the help for the request specs.
    config.include ValidUserRequestHelper, :type => :request
end
EOF
inject_into_file "spec/factories/users.rb", after: "factory :user do\n" do
<<-EOF
    sequence(:username) { |n| "test\#{n}" }
    sequence(:email) { |n| "test\#{n}@exampl.com" }
    password "password"
    password_confirmation "password"
EOF
end
