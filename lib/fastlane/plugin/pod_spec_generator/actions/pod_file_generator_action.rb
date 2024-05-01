require 'fastlane/action'
require_relative '../helper/pod_file_builder'
module Fastlane
  module Actions

    class PodFileGeneratorAction < Action

      def self.run(params)
        builder = PodFileBuilder.new
        builder.apply_local_spm_fix = params[:apply_local_spm_fix]
        builder.targets = params[:targets]
        builder.use_frameworks = params[:use_frameworks]
        if params[:platform]
          builder.platform = params[:platform].reduce([]) do |content, pair|
            content += [":#{pair[0]}", pair[1]]
          end
        end

        output = builder.build_pod_file_string
        File.write("#{params[:folder]}/Podfile", output)

      end

      def self.description
        "Generate a simple pod spec for CI automation"
      end

      def self.authors
        ["Swift Gurus / Alex Crowe"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "Generate a simple pod file for CI automation, local and prod specs"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :use_frameworks,
                                       env_name: "POD_FILE_GENERATOR_VERSION",
                                       description: "Version String",
                                       type: TrueClass,
                                       default_value: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :apply_local_spm_fix,
                                       env_name: "POD_LOCAL_SPM",
                                       description: "Use local spm",
                                       type: TrueClass,
                                       default_value: false,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :targets,
                                       description: "Targets",
                                       optional: false,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :folder,
                                       env_name: "POD_FILE_GENERATOR_FOLDER",
                                       description: "Folder for the file String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :platform,
                                       env_name: "POD_FILE_GENERATOR_PLATFORM",
                                       description: "Platform",
                                       default_value: {ios: "14.0"},
                                       optional: true,
                                       type: Hash)

        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
      end
  end
end
