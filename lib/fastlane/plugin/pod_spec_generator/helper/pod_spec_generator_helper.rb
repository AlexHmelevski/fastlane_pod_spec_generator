require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class PodSpecGeneratorHelper

      def self.show_message
        UI.message("Hello from the pod_spec_generator plugin helper!")
      end
    end
  end
end
