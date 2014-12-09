def root
  @root ||= File.expand_path File.dirname __FILE__
end

def perform action
  eval File.read File.join root, "#{action}.rb"
end

perform :git_init
perform :change_source
