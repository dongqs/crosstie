# simple_form
generate 'simple_form:install --bootstrap'

# default horizontal form
{
  'config.default_wrapper = :vertical_form' =>
      'config.default_wrapper = :horizontal_form',
  'check_boxes: :vertical_radio_and_checkboxes,' =>
      'check_boxes: :horizontal_radio_and_checkboxes,',
  'radio_buttons: :vertical_radio_and_checkboxes,' =>
      'radio_buttons: :horizontal_radio_and_checkboxes,',
  'file: :vertical_file_input,' =>
      'file: :horizontal_file_input,',
  'boolean: :vertical_boolean,' =>
      'boolean: :horizontal_boolean,',
}.each do |from, to|
  gsub_file "config/initializers/simple_form_bootstrap.rb", from, to
end

#remove_file "lib/templates/slim/scaffold/_form.html.slim"
#create_file "lib/templates/slim/scaffold/_form.html.slim", <<-EOF
#= simple_form_for(@<%= singular_table_name %>, html: { class: 'form-horizontal' }, wrapper: :horizontal_form, wrapper_mappings: { check_boxes: :horizontal_radio_and_checkboxes, radio_buttons: :horizontal_radio_and_checkboxes, file: :horizontal_file_input, boolean: :horizontal_boolean }) do |f|
#  = f.error_notification
#
#  .form-inputs
#<%- attributes.each do |attribute| -%>
#    = f.<%= attribute.reference? ? :association : :input %> :<%= attribute.name %>
#<%- end -%>
#
#  .form-actions
#    = f.button :submit
#EOF
