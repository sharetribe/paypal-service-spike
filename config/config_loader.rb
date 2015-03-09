require 'yaml'
require 'ostruct'

module ConfigLoader
  USER_CONFIGS = "config/config.yml"

  module_function

  # Load configurations in order:
  # - default
  # - user
  # - env
  #
  # User configs override default configs and env configs override both user and default configs
  def load_app_config(keys)
    user_configs = read_yaml_file(USER_CONFIGS)

    values = keys.map { |key| user_configs[key.to_s] }

    Struct.new(*keys).new(*values)
  end

  def read_yaml_file(file)
    file_content =
      if File.exists?(file)
        YAML.load_file(file)
      end

    file_content || {}
  end
end
