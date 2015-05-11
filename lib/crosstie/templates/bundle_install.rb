if config['options']['local']
  run "bundle install --local"
else
  run "bundle install --verbose"
end
