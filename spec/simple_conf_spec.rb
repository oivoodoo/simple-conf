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

