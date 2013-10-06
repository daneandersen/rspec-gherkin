require 'spec_helper'

describe 'The CLI', :type => :integration do
  it 'can run features' do
    @result = %x(rspec -fs features/*.feature 2>&1)
  end

  context 'runing features specs on their own' do
    before do
      @result = %x(rspec --tag feature --format documentation 2>&1)
    end

    it 'prepends features with "Feature: " prefix' do
      expect(@result).to include('Feature: A simple feature')
    end

    it 'prepends scenarios with "Scenario: " prefix' do
      expect(@result).to include('Scenario: A simple scenario')
    end

    it 'passes all specs' do
      expect(@result).to include('2 examples, 0 failures')
    end
  end

  # it "shows the correct description" do
  #   @result.should include('A simple feature')
  #   @result.should include('is a simple feature')
  # end

  # it "prints out failures and successes" do
  #   @result.should include('35 examples, 3 failures, 5 pending')
  # end

  # it "includes features in backtraces" do
  #   @result.should include('examples/errors.feature:5:in `raise error')
  # end

  # it "includes the right step name when steps call steps" do
  #   @result.should include("No such step: 'this is an unimplemented step'")
  # end
end
