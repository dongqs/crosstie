# .gitignore
append_file ".gitignore", <<-EOF
dump.rdb
/config/database.yml
/config/secrets.yml
/config/ldap.yml
/config/sidekiq.yml
*.swp
/coverage
.DS_Store
EOF
