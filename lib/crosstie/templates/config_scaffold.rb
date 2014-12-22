# application.rb
# stop scaffold from generating css, js, helper, test for helper, test for views
inject_into_file 'config/application.rb', after: "# scaffold\n" do
<<-EOS
    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.test_framework :rspec, view_specs: false, request_specs: false
    end
EOS
end
