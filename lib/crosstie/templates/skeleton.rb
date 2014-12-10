# user.rb
inject_into_file "app/models/user.rb", before: 'end' do
<<-EOF

  # crosstie skeleton

  # ldap

  # username

  # authentication_token

  # authorization

EOF
end

# application_controller.rb
inject_into_file "app/controllers/application_controller.rb", before: 'end' do
<<-EOF

  # controller_helpers

  # authentication_token

  # authorization

EOF
end
