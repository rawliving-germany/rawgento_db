require "rawgento_db/version"
require "rawgento_db/query"
require 'yaml'

module RawgentoDB
  DEFAULT_CONFIG_FILE = "rawgento_db-config.yml"
  def self.settings file=DEFAULT_CONFIG_FILE
    @@settings ||= YAML.load_file(file || DEFAULT_CONFIG_FILE)
    @@settings
  end
end
