require File.join(File.dirname(__FILE__), 'spec_helper')

class Car
  include Mongoid::Document
  references_many :wheels
end

class Wheel
  include Mongoid::Document
end

describe Mongoid::Associations::ClassMethods, "#references_many" do
  before do
    @wheels = [Wheel.create!, Wheel.create!, Wheel.create!, Wheel.create!]
    @car = Car.create!(:wheels => @wheels)
    @car.reload
  end

  it "should allow access to the referenced objects" do
    @car.wheels.should == @wheels
  end

  # it should inflect foreign key properly
end
