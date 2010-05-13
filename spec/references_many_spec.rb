require File.join(File.dirname(__FILE__), 'spec_helper')

class Car
  include Mongoid::Document
  references_many :wheels
end

class Wheel
  include Mongoid::Document
end

describe Mongoid::Associations::ClassMethods, "#references_many" do
  context "for a car which references 4 wheels" do
    before do
      @wheels = [Wheel.create!, Wheel.create!, Wheel.create!, Wheel.create!]
      @car = Car.create!(:wheels => @wheels)
      @car.reload
    end

    it "should allow access to the referenced objects" do
      @car.wheels.should == @wheels
    end
    
    it "should inflect the foreign key properly" do
      @car.wheel_ids.should == @wheels.map {|w| w.id }
    end
  end

  it "should return [] if no references are supplied" do
    car = Car.create!
    car.wheels.should == []
  end
end