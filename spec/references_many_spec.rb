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

  it "should save wheels which are passed in at creation time if necessary" do
    @wheel1 = Wheel.new
    @wheel2 = Wheel.new
    @car = Car.create!(:wheels => [@wheel1, @wheel2])
    @car.reload
    @car.wheels.should == [@wheel1, @wheel2]
  end

  describe "#<<" do
    before do
      @car = Car.new
    end

    it "should append a single document, saving it if necessary" do
      @wheel = Wheel.new
      @wheel.new_record?.should == true

      @car.wheels << @wheel
      @wheel.new_record?.should == false

      @car.wheels.should == [@wheel]
      @car.save!
      @car.reload
      @car.wheels.should == [@wheel]
    end

    it "should append multiple documents, saving them if necessary" do
      @wheel1 = Wheel.create!
      @wheel1.expects(:save).never
      @wheel1.expects(:save!).never
      @wheel2 = Wheel.new

      @car.wheels.<<(@wheel1, [@wheel2])
      @wheel2.new_record?.should == false

      @car.wheels.should == [@wheel1, @wheel2]
      @car.save!
      @car.reload
      @car.wheels.should == [@wheel1, @wheel2]
    end

    # it should append after existing items
  end
end
