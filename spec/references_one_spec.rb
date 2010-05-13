require File.join(File.dirname(__FILE__), 'spec_helper')

class Widget
  include Mongoid::Document
  references_one :button
end

class Button
  include Mongoid::Document
end

describe Mongoid::Associations::ClassMethods, "#references_one" do
  before do
    @button = Button.create!
    @widget = Widget.create!(:button => @button)
    [@button, @widget].each {|d| d.reload }
  end

  it "should allow access to the referenced object" do
    @widget.button.should == @button
  end

  it "should allow assignment of nil" do
    @widget.button = nil
    @widget.button.should == nil
    @widget.save!
    @widget.reload
    @widget.button.should == nil
  end

  it "should allow assignment of another referenced object" do
    @button2 = Button.create!
    @widget.button = @button2
    @widget.button.should == @button2
    @widget.save!
    @widget.reload
    @widget.button.should == @button2
  end
end
