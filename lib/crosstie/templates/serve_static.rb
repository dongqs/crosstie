# production.rb
# serve static files
gsub_file "config/environments/production.rb", "config.serve_static_assets = false", "config.serve_static_assets = true"
