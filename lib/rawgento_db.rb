require "rawgento_db/version"
require "rawgento_db/query"
require 'yaml'

module RawgentoDB
  def self.settings file: "rawgento_db-config.yml"
    YAML.load_file file
  end
end
