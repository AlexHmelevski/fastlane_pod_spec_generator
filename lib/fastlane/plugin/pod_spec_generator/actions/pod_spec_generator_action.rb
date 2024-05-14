require 'fastlane/action'
require_relative '../helper/pod_spec_builder'

module Fastlane
  module Actions

    class PodSpecGeneratorAction < Action

      def self.run(params)
        builder = PodSpecBuilder.new
        builder.author = params[:author]
        builder.version = params[:version]
        builder.summary = params[:summary]
        builder.name = params[:name]
        builder.description = params[:description]
        builder.homepage = params[:homepage]
        builder.license = params[:license]
        (params[:dependencies]).each do |dep|
          builder.add_dependency(dep[:name], dep[:version])
        end
        builder.source = params[:source]
        builder.source_files = params[:source_files]
        builder.swift_version = params[:swift_version]
        builder.spm_local_dependencies = params[:spm_local_dependencies]
        builder.platform = params[:platform].reduce([]) do |content, pair|
          content += pair
        end
        (params[:subspecs] || []).each do |dep|
          builder.add_subspec(dep[:name], dep[:local_files], dep[:dependencies])
        end
        builder.static_framework = params[:static_framework]
        builder.vendored_frameworks = params[:vendored_frameworks]
        output = builder.build_pod_spec_string
        FileUtils.mkdir_p params[:folder]
        File.write("#{params[:folder]}/#{params[:name]}.podspec", output)

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
        "Generate a simple pod spec for CI automation, local and prod specs"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "POD_SPEC_GENERATOR_VERSION",
                                       description: "Version String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :summary,
                                       env_name: "POD_SPEC_GENERATOR_SUMMARY",
                                       description: "Summary String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :description,
                                       env_name: "POD_SPEC_GENERATOR_DESCRIPTION",
                                       description: "Description String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "POD_SPEC_GENERATOR_NAME",
                                       description: "Pod Name String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :homepage,
                                       env_name: "POD_SPEC_GENERATOR_HOMEPAGE",
                                       description: "Homepage",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :license,
                                       description: "License Object",
                                       default_value: { type: "MIT", file: "LICENSE" },
                                       optional: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :dependencies,
                                       description: "Dependencies array",
                                       default_value: [],
                                       optional: true,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :source,
                                       description: "Source",
                                       optional: true,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :author,
                                       description: "Author",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :source_files,
                                       description: "Source Files",
                                       default_value: [],
                                       optional: true,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :swift_version,
                                       env_name: "POD_SPEC_GENERATOR_SWIFT_VERSION",
                                       description: "Source Files",
                                       default_value: "5.9",
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :folder,
                                       env_name: "POD_SPEC_GENERATOR_FOLDER",
                                       description: "Folder for the file String",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :platform,
                                       env_name: "POD_SPEC_GENERATOR_PLATFORM",
                                       description: "Platform",
                                       default_value: {ios: "14.0"},
                                       optional: true,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :spm_local_dependencies,
                                       description: "Local spm dependencies",
                                       default_value: [],
                                       optional: true,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :subspecs,
                                       description: "Additional subspecs",
                                       default_value: [],
                                       optional: true,
                                       type: Array),
          FastlaneCore::ConfigItem.new(key: :static_framework,
                                       description: "Static Framework",
                                       default_value: false,
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :vendored_frameworks,
                                       description: "Vendored Framework",
                                       default_value: nil,
                                       optional: true,
                                       type: String)


        ]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
      end
  end
end
