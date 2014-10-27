require 'spec_helper'

module Rails
  def self.env
    "staging"
  end
end

class Configuration
  include SimpleConf
end

class Options
  include SimpleConf
end

module ConfigModule
  class Options
    include SimpleConf
  end
end

class CamelCaseConfig
  include SimpleConf
end

class Settings
  def self.env
    'test'
  end

  include SimpleConf
end

class SettingsWithFilename
  def self.config_file_name
    'settings'
  end

  include SimpleConf
end

describe SimpleConf do
  context "on include to config class generate properties" do
    it { Configuration.staging.domain.should eq("staging.example.com") }

    it "should work properly with collections" do
      expect(Configuration.staging.links).to eq([
        "test1.example.com",
        "test2.example.com",
      ])
    end

    it { expect(Configuration.production.domain).to eq("production.example.com") }
  end

  context "on include to options class generate properties with only one key and value" do
    it { expect(Options.domain).to eq("example.com") }
  end
end

describe SimpleConf do
  context "on include properties depending on rails environment" do
    it { expect(Configuration.domain).to eq("staging.example.com") }
  end
end

describe SimpleConf do
  it 'on include properties depenending on env method' do
    expect(Settings.domain).to eq('test.example.com')
  end
end

describe SimpleConf do
  class TestObject ; end

  before do
    File.stub(:exists?).and_return(true)
    file = double('file', :read => attrib('test').to_yaml)
    File.stub(:open).and_return(file)
  end

  context "when we have env params in the configuration file" do
    before { ENV['simple_conf_test_password'] = 'password' }

    after { ENV['simple_conf_test_password'] = nil }

    let(:loader) { SimpleConf::Loader.new(TestObject) }

    context "on run loader" do
      before { loader.run }

      it "should return username" do
        expect(TestObject.test.username).to eq('fred')
      end

      it "should return password fetched from the environment" do
        expect(TestObject.test.password).to eq('password')
      end
    end
  end

  def attrib(environment)
    {
      environment => {
          "username" => "fred",
          "password" => "<%= ENV['simple_conf_test_password'] %>"
      }
    }
  end
end

describe SimpleConf do
  it 'should be possible to use defined name in the settings class for loading the configuration file' do
    expect(SettingsWithFilename.test.domain).to eq('test.example.com')
  end
end

class Options2
  include SimpleConf
end

describe SimpleConf do
  it 'supports .local.yml file for loading extra options' do
    expect(Options2).to respond_to(:group1)
    expect(Options2).to respond_to(:group2)
  end
end

describe SimpleConf do
  it 'should properly handle camel case names' do
    expect(CamelCaseConfig.domain).to eq('staging.example.com')
  end
end

