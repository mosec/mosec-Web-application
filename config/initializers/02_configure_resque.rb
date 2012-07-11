REDIS_CONFIGURATION = YAML.load(ERB.new(File.read("#{Rails.root}/config/redis.yml")).result)[Rails.env]

Resque.redis = REDIS_CONFIGURATION