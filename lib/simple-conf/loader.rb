require 'ostruct'
require 'yaml'
require 'erb'

module SimpleConf
  Loader = Struct.new(:klass) do
    def initialize(klass)
      super(klass)

      klass.class_eval %Q{
        class << self
          attr_reader :keys
        end

        @keys = []
      }
    end

    def run
      paths.each do |path|
        load_file(path)
        load_file_by_rails_env(path)
        load_file_by_klass_env(path)
      end
    end

    def load_file_by_rails_env(path)
      yaml_file(path).fetch(Rails.env, {}).each_pair do |key, value|
        set(key, value)
      end if rails_environment_defined?
    end

    def load_file(path)
      yaml_file(path).each_pair do |key, value|
        set(key, value)
      end
    end

    def load_file_by_klass_env(path)
      yaml_file(path).fetch(klass.env, {}).each_pair do |key, value|
        set(key, value)
      end if klass.respond_to?(:env)
    end

    def paths
      [
        "./config/#{config_file_name}.yml",
        "./config/#{config_file_name}.local.yml",
      ]
    end

    def config_file_name
      klass.respond_to?(:config_file_name) ?
        klass.config_file_name :
        "#{underscore(klass.name.split("::").last)}"
    end

    def underscore(camel_case_string)
      camel_case_string.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

    def yaml_file(path)
      return {} unless File.exists?(path)
      content = File.open(path).read
      YAML.load(ERB.new(content).result)
    end

    private

    def define(key)
      klass.class_eval %Q{
        class << self
          attr_reader :#{key}
        end

        @keys.push(:#{key})
      }
    end

    class << self
      attr_reader :keys
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

