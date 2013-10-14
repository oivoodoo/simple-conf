require 'ostruct'
require 'yaml'
require 'erb'

module SimpleConf
  Loader = Struct.new(:klass) do
    def run
      yaml_file.each_pair do |key, value|
        set(key, value)
      end

      yaml_file.fetch(Rails.env, {}).each_pair do |key, value|
        set(key, value)
      end if rails_environment_defined?

      yaml_file.fetch(klass.env, {}).each_pair do |key, value|
        set(key, value)
      end if klass.respond_to?(:env)
    end

    def path
      "./config/#{config_file_name}"
    end

    def config_file_name
      klass.respond_to?(:config_file_name) ?
        klass.config_file_name :
        "#{klass.name.downcase.split("::").last}.yml"
    end

    def yaml_file
      content = File.open(path).read
      YAML.load(ERB.new(content).result)
    end

    private

    def define(key)
      klass.class_eval %Q{
        class << self
          attr_reader :#{key}
        end
      }
    end

    def set(key, value)
      define(key)

      struct = OpenStruct.new(value) rescue value
      klass.instance_variable_set(:"@#{key}", struct)
    end

    def rails_environment_defined?
      rails_klass = Module.const_get('Rails')
      return rails_klass.is_a?(Module)
    rescue NameError
      return false
    end
  end

  def self.included(base)
    loader = Loader.new(base)
    loader.run
  end
end

