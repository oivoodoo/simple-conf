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

class Settings
  def self.env
    'test'
  end

  include SimpleConf
end

describe SimpleConf do
  context "on include to config class generate properties" do
    it { Configuration.staging.domain.should == "staging.example.com" }

    it "should work properly with collections" do
      Configuration.staging.links.should == [
        "test1.example.com",
        "test2.example.com"
      ]
    end

    it { Configuration.production.domain.should == "production.example.com" }
  end

  context "on include to options class generate properties with only one key and value" do
    it { Options.domain.should == "example.com" }
  end
end

describe SimpleConf do
  context "on include properties depending on rails environment" do
    it { Configuration.domain.should == "staging.example.com" }
  end
end

describe SimpleConf do
  context 'on include properties depenending on env method' do
    Settings.domain.should == 'test.example.com'
  end
end

class TestObject ; end

describe SimpleConf do
  before do
    file = double('file', :read => attrib('test').to_yaml)
    File.stub!(:open).and_return file
  end

  context "when we have env params in the configuration file" do
    before { ENV['simple_conf_test_password'] = 'password' }

    after { ENV['simple_conf_test_password'] = nil }

    let(:loader) { SimpleConf::Loader.new(TestObject) }

    context "on run loader" do
      before { loader.run }

      it "should return username" do
        TestObject.test.username.should == 'fred'
      end

      it "should return password fetched from the environment" do
        TestObject.test.password.should == 'password'
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
