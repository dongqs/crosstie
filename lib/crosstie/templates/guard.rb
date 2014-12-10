# guard
run "bundle exec guard init rspec"
inject_into_file "Guardfile", ", cmd: 'spring rspec'", after: ":rspec"
