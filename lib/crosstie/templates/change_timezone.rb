# application.rb
# change timezone to Beijing
inject_into_file 'config/application.rb', after: "# timezone\n" do
<<-EOF
  "config.time_zone = 'Beijing'"
EOF
end
