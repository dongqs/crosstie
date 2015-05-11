append_file "db/seeds.rb", <<-EOF
user = User.create! username: "admin", email: "admin@example.com", password: "password"
puts "sign in with:\n\tusername: admin\n\tpassword: password"
EOF
rake "db:seed"
