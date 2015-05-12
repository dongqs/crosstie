# helper
inject_into_file "app/helpers/application_helper.rb", after: "module ApplicationHelper\n" do
<<-EOF

  def link_for obj, name = :name, i: false, b: false
    return nil unless obj
    raise "not respond to \#{name}" unless obj.respond_to? name

    html = link_to obj.send(name), obj
    html = content_tag :i, html if i
    html = content_tag :b, html if b
    html
  end
EOF
end
