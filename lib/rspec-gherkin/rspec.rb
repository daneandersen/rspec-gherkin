require "rspec-gherkin"
require "rspec"

module RspecGherkin
  module RSpec

    # This module hooks RspecGherkin into RSpec by duck punching the load Kernel
    # method. If the file is a feature file, we run RspecGherkin instead.
    module Loader
      def load(*a, &b)
        if a.first.end_with?('.feature')
          require_if_exists 'gherkin_helper'
          require_if_exists 'spec_helper'

          RspecGherkin::RSpec.run(a.first)
        else
          super
        end
      end

      private

      def require_if_exists(filename)
        require filename
      rescue LoadError => e
        # Don't hide LoadErrors raised in the spec helper.
        raise unless e.message.include?(filename)
      end
    end

    class << self
      def run(feature_file)
        RspecGherkin::Builder.build(feature_file).features.each do |feature|
          describe feature.name, feature.metadata_hash do
            before do
              # This is kind of a hack, but it will make RSpec throw way nicer exceptions
              example.metadata[:file_path] = feature_file

              # feature.backgrounds.map(&:steps).flatten.each do |step|
              #   run_step(feature_file, step)
              # end
            end
            feature.scenarios.each do |scenario|
              # describe scenario.name, scenario.metadata_hash do
              #   it scenario.steps.map(&:description).join(' -> ') do
              #     scenario.steps.each do |step|
              #       run_step(feature_file, step)
              #     end
              #   end
              # end
            end
          end
        end
      end
    end
  end
end
