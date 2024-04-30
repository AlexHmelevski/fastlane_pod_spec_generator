# frozen_string_literal: true

require 'rspec'

RSpec.describe PodFileBuilder do

  context 'targets passed ' do
    it 'returns generated pod file' do
      expected = "use_frameworks!\n" \
                 "plugin 'fastlane-plugin-pod_spec_generator'\n" \
                 "target 'MyTarget' do\n" \
                 "\tpod 'Networking', ~> '1,2,3'\n\n" \
                 "end\n" \
                 "target 'MyTarget2' do\n" \
                 "\tpod 'Networking2', ~> '1,2,3'\n\n" \
                 "end\n"
      builder = described_class.new
      builder.apply_local_spm_fix = true
      builder.targets = [
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
      expect(builder.build_pod_file_string).to eq(expected)

    end
  end
end
