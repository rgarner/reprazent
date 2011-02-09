require "spec_helper"

describe Reprazent::VCardHelper do
  class Helper
    include Reprazent::VCardHelper
  end

  let(:helper) { Helper.new }

  it "should allow missing methods to act as vCard keys" do
    helper.ORG('ACAS').should == 'ORG:ACAS'
  end

  it "should allow a hash parameter to supply extra values" do
    helper.TEL('0113 2555075', :TYPE => [:WORK, :VOICE]).should == 'TEL;TYPE=WORK,VOICE:0113 2555075'
  end

  it "should allow a single hash param to supply extras" do
    helper.ADR('My address', :TYPE => :WORK).should == 'ADR;TYPE=WORK:My address'
  end
end