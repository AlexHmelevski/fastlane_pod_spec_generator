# frozen_string_literal: true

require 'rspec'

describe Fastlane::Actions::PodFileGeneratorAction do

  let(:sut) { Fastlane::Actions::PodFileGeneratorAction }
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
                 "\tpod 'Networking2', :path => '../'\n\n" \
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
                      {name: "Networking2", version: ":path => '../'"}
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
