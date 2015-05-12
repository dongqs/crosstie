inject_into_file "config/application.rb", after: "# web_console\n" do
<<-EOF
    config.web_console.whitelisted_ips = '0.0.0.0/0'
EOF
end
