require 'helper'

describe Manybots do
  after do
    Manybots.reset
  end

  describe '.respond_to?' do
    it "should take an optional argument" do
      Manybots.respond_to?(:new, true).should be_true
    end
  end

  describe ".new" do
    it "should return a Manybots::Client" do
      Manybots.new.should be_a Manybots::Client
    end
  end


  describe ".endpoint" do
    it "should return the default endpoint" do
      Manybots.endpoint.should == Manybots::Config::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Manybots.endpoint = 'http://tumblr.com/'
      Manybots.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Manybots.user_agent.should == Manybots::Config::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Manybots.user_agent = 'Custom User Agent'
      Manybots.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do
    Manybots::Config::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Manybots.configure do |config|
          config.send("#{key}=", key)
          Manybots.send(key).should == key
        end
      end
    end
  end

end
