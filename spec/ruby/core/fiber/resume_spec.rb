require_relative '../../spec_helper'
require_relative 'shared/resume'

describe "Fiber#resume" do
  it_behaves_like :fiber_resume, :resume
end

describe "Fiber#resume" do
  it "runs until Fiber.yield" do
    obj = mock('obj')
    obj.should_not_receive(:do)
    fiber = Fiber.new { 1 + 2; Fiber.yield; obj.do }
    fiber.resume
  end

  it "resumes from the last call to Fiber.yield on subsequent invocations" do
    fiber = Fiber.new { Fiber.yield :first; :second }
    fiber.resume.should == :first
    fiber.resume.should == :second
  end

  it "sets the block parameters to its arguments on the first invocation" do
    first = mock('first')
    first.should_receive(:arg).with(:first).twice

    fiber = Fiber.new { |arg| first.arg arg; Fiber.yield; first.arg arg; }
    fiber.resume :first
    fiber.resume :second
  end

  it "raises a FiberError if the Fiber tries to resume itself" do
    fiber = Fiber.new { fiber.resume }
    -> { fiber.resume }.should raise_error(FiberError, /current fiber/)
  end

  it "returns control to the calling Fiber if called from one" do
    fiber1 = Fiber.new { :fiber1 }
    fiber2 = Fiber.new { fiber1.resume; :fiber2 }
    fiber2.resume.should == :fiber2
  end

  # Redmine #595
  it "executes the ensure clause" do
    code = <<-RUBY
      f = Fiber.new do
        begin
          Fiber.yield
        ensure
          puts "ensure executed"
        end
      end

      # The apparent issue is that when Fiber.yield executes, control
      # "leaves" the "ensure block" and so the ensure clause should run. But
      # control really does NOT leave the ensure block when Fiber.yield
      # executes. It merely pauses there. To require ensure to run when a
      # Fiber is suspended then makes ensure-in-a-Fiber-context different
      # than ensure-in-a-Thread-context and this would be very confusing.
      f.resume

      # When we execute the second #resume call, the ensure block DOES exit,
      # the ensure clause runs.
      f.resume

      exit 0
    RUBY

    ruby_exe(code).should == "ensure executed\n"
  end

  it "can work with Fiber#transfer" do
    fiber1 = Fiber.new { true }
    fiber2 = Fiber.new { fiber1.transfer; Fiber.yield 10 ; Fiber.yield 20; raise }
    fiber2.resume.should == 10
    fiber2.resume.should == 20
  end

  it "raises a FiberError if the Fiber attempts to resume a resuming fiber" do
    root_fiber = Fiber.current
    fiber1 = Fiber.new { root_fiber.resume }
    -> { fiber1.resume }.should raise_error(FiberError, /attempt to resume a resuming fiber/)
  end
end
