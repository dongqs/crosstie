append_file "db/seeds.rb", <<-EOF
user = User.create! username: "admin", email: "admin@example.com", password: "password"
Role::USER_ROLES.each do |role|
  user.grant role
end
puts "sign in with:\n\tusername: admin\n\tpassword: password"
EOF
rake "db:seed"
