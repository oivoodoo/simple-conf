require 'ostruct'
require 'yaml'

module SimpleConf
  class Loader
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def run
      yaml_file.each_pair do |key, value|
        set(key, value)
      end

      yaml_file.fetch(Rails.env, {}).each_pair do |key, value|
        set(key, value)
      end if rails_environment_defined?
    end

    def path
      class_name = klass.name.downcase.split("::").last

      "./config/#{class_name}.yml"
    end

    def yaml_file
      content = File.open(path).read
      YAML.load(content)
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

