# scaffold resources

if config['resources']

  config['resources'].each do |resource, fields|

    generate "scaffold", resource, *fields

    rake "db:migrate"

    inject_into_file "spec/controllers/#{resource.tableize}_controller_spec.rb", after: "RSpec.describe #{resource.tableize.camelize}Controller, type: :controller do\n" do
<<-EOF

  before do
    sign_in_user
    @#{resource} = FactoryGirl.build(:#{resource})
  end
EOF
    end

    gsub_file "spec/controllers/#{resource.tableize}_controller_spec.rb",
        'skip("Add a hash of attributes valid for your model")',
        "@#{resource}.attributes"

    inject_into_file "app/views/layouts/_navigation_links.html.slim", after: "- if user_signed_in?\n" do
<<-EOF
  li = link_to '#{resource.tableize.titleize}', #{resource.tableize}_path
EOF
    end

  end

  run "bundle exec annotate"
end
