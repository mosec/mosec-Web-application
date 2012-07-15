ELASTIC_SEARCH_CONFIGURATION = YAML.load(ERB.new(File.read("#{Rails.root}/config/elastic_search.yml")).result)[Rails.env]

Tire::Configuration.url ELASTIC_SEARCH_CONFIGURATION['url']