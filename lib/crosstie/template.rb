git :init
git add: '.'
git commit: "-a -m 'rails new #{app_path}'"

gsub_file "Gemfile", "https://rubygems.org", "https://ruby.taobao.org"
