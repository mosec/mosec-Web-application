CONTEXT_IO_CONFIGURATION = YAML.load_file("#{Rails.root}/config/context_io.yml")[Rails.env]

ContextIO.configure do |configuration|
  configuration.consumer_key = CONTEXT_IO_CONFIGURATION['consumer_key']
  configuration.consumer_secret = CONTEXT_IO_CONFIGURATION['consumer_secret']
end
