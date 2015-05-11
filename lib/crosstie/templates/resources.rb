# scaffold resources
if config['resources']
  config['resources'].each do |resource, fields|
    generate "scaffold", resource, *fields
    rake "db:migrate"
    inject_into_file "spec/controllers/#{resource.tableize}_controller_spec.rb", after: "RSpec.describe #{resource.pluralize.camelize}Controller, type: :controller do\n" do
<<-EOF

  before { sign_in_user }
EOF
    end

    gsub_file "spec/controllers/#{resource.tableize}_controller_spec.rb",
        'skip("Add a hash of attributes valid for your model")',
        "FactoryGirl.build(:#{resource}).attributes"
  end

  run "bundle exec annotate"
end
