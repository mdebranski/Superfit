require 'ostruct'

unless Object.const_defined? :APP_CONFIG
  app_config = Hash.new

  base_config_file = Rails.root.join("config", "config.yml")
  if base_config_file.file?
    puts "Loading #{base_config_file}..."
    base_config = YAML.load(ERB.new(base_config_file.read).result)[Rails.env]
    app_config.merge! base_config unless base_config.nil?
  end

  environment_file = Rails.root.join("config", "environments", "#{Rails.env}.yml")
  if environment_file.file?
    puts "Loading #{environment_file}..."
    environment_config = YAML.load(ERB.new(environment_file.read).result)
    app_config.merge! environment_config unless environment_config.nil?
  else
    raise "You must create an environment config file for development. See instructions in config/environments/development.yml.example" if Rails.env.development?
  end

  APP_CONFIG = OpenStruct.new(app_config).freeze
end
