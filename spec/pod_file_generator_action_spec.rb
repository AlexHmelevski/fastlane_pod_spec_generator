# frozen_string_literal: true

require 'rspec'

describe Fastlane::Actions::PodFileGeneratorAction do

  let(:sut) { Fastlane::Actions::PodFileGeneratorAction }
  let(:expected_settings_string) {
    "Pod::Spec.new do |s|" \
      "\n\ts.author = {\"Name\"=>\"email\"}" \
      "\n\ts.description = 'Description'" \
      "\n\ts.homepage = 'Homepage'" \
      "\n\ts.license = {:type=>\"MIT\", :file=>\"LICENSE\"}" \
      "\n\ts.name = 'Name'" \
      "\n\ts.platform = [:ios, \"13.0\"]" \
      "\n\ts.source = {:http=>\"my url\"}" \
      "\n\ts.source_files = [\"SourceCode/**/*.{swift}\", \"SourceCode/**/*.{h}\"]" \
      "\n\ts.summary = 'Summary'" \
      "\n\ts.swift_version = '5.9'" \
      "\n\ts.version = 'Version'" \
      "\n" \
      "\n\ts.dependency 'Dependency1'" \
      "\n\ts.dependency 'Dependency2', ~>'1.0.0'" \
      "\n"\
      "\n\ts.local_spm_dependency(path: 'mypath', products: [\"SPM1\"])"\
      "\nend"
  }
  let(:folder_path) {
    "test_folder"
  }

  before() do
    FileUtils.remove_dir(folder_path, force: true)
    FileUtils.mkdir(folder_path)
  end

  after() do
    FileUtils.remove_dir(folder_path, force: true)
  end

  describe '#run' do

    it 'Generates local podfile' do
      expected = "use_frameworks!\n" \
        "plugin 'fastlane-plugin-pod_spec_generator'\n" \
        "target 'MyTarget' do\n" \
        "\tpod 'Networking', ~> '1,2,3'\n\n" \
        "end\n" \
        "target 'MyTarget2' do\n" \
        "\tpod 'Networking2', ~> '1,2,3'\n\n" \
        "end\n"
      sut.run({
                use_frameworks: true,
                apply_local_spm_fix: true,
                folder: folder_path,
                targets: [
                  {
                    name: "MyTarget",
                    dependencies: [
                      {name: "Networking", version: "~> '1,2,3'"}
                    ]
                  },
                  {
                    name: "MyTarget2",
                    dependencies: [
                      {name: "Networking2", version: "~> '1,2,3'"}
                    ]
                  }

                ]
              })
      expect(read_file_data).to eq(expected)
    end

    it 'Generates podfil with no plugin' do
      expected = "use_frameworks!\n" \
        "target 'MyTarget' do\n" \
        "\tpod 'Networking', ~> '1,2,3'\n\n" \
        "end\n" \
        "target 'MyTarget2' do\n" \
        "\tpod 'Networking2', ~> '1,2,3'\n\n" \
        "end\n"
      sut.run({
                use_frameworks: true,
                folder: folder_path,
                targets: [
                  {
                    name: "MyTarget",
                    dependencies: [
                      {name: "Networking", version: "~> '1,2,3'"}
                    ]
                  },
                  {
                    name: "MyTarget2",
                    dependencies: [
                      {name: "Networking2", version: "~> '1,2,3'"}
                    ]
                  }

                ]
              })
      expect(read_file_data).to eq(expected)
    end
  end

  def read_file_data
    File.read("#{folder_path}/Podfile")
  end
end
