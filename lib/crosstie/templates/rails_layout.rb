generate 'layout:install', 'bootstrap3', '--force'
generate 'layout:devise', 'bootstrap3'

remove_file "app/views/layouts/_navigation_links.html.erb"
create_file "app/views/layouts/_navigation_links.html.slim", <<-EOF
- if user_signed_in?
  li = link_to 'Users', users_path
  li = link_to "Sign out", destroy_user_session_path, method: :delete
- else
  li = link_to "Sign in", new_user_session_path
  li = link_to "Sign up", new_user_registration_path
EOF
