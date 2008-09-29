require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes'

describe "Kernel#system" do
  it "can run basic things that exist" do
    begin
      result = false

      File.exist?("happy").should == false
      result = system("touch happy")
      result.should == true
      File.exist?("happy").should == true
    ensure
      File.unlink "happy"
    end
  end

  it "returns false when it can't" do
    result = system("sad")
    result.should == false
  end

  it "uses /bin/sh if freaky shit is in the command" do
    begin
      result = false

      File.exist?("happy").should == false
      result = system("echo woot > happy")
      result.should == true
      File.exist?("happy").should == true
    ensure
      File.unlink "happy"
    end
  end

  it "is a private method" do
    Kernel.private_instance_methods.should include("system")
  end
  
  it "expands shell variables when given a single string argument" do
    ENV['TEST_SH_EXPANSION'] = 'foo'
    helper_script = File.dirname(__FILE__) + '/fixtures/check_expansion.rb'
    shell_var = platform_is(:windows) ? '%TEST_SH_EXPANSION%' : '$TEST_SH_EXPANSION'
    result = system("ruby #{helper_script} #{shell_var} foo")
    result.should == true
  end
  
  it "does not expand shell variables when given multiples arguments" do
    ENV['TEST_SH_EXPANSION'] = 'foo'
    helper_script = File.dirname(__FILE__) + '/fixtures/check_expansion.rb'
    shell_var = platform_is(:windows) ? '%TEST_SH_EXPANSION%' : '$TEST_SH_EXPANSION'
    result = system("ruby", helper_script, shell_var, "foo")
    result.should == false
  end
end

describe "Kernel.system" do
  it "needs to be reviewed for spec completeness"
end
