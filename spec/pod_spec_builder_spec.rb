# frozen_string_literal: true
require 'rspec'

RSpec.describe PodSpecBuilder do
  let(:expected_settings_string) {
    "Pod::Spec.new do |s|" \
      "\n\ts.author = {\"Name\"=>\"email\"}" \
      "\n\ts.description = 'Description'" \
      "\n\ts.homepage = 'Homepage'" \
      "\n\ts.license = {:type=>\"MIT\", :file=>\"LICENSE\"}" \
      "\n\ts.name = 'Name'" \
      "\n\ts.platform = [\"ios\", \"13.0\"]" \
      "\n\ts.source = {:http=>\"my url\"}" \
      "\n\ts.source_files = [\"SourceCode/**/*.{swift}\", \"SourceCode/**/*.{h}\"]" \
      "\n\ts.summary = 'Summary'" \
      "\n\ts.swift_version = '5.9'" \
      "\n\ts.version = 'Version'" \
      "\n\ts.static_framework = true" \
      "\n" \
      "\n\ts.dependency 'Dependency1'" \
      "\n\ts.dependency 'Dependency2', ~>'1.0.0'" \
      "\n" \
      "\n\ts.subspec 'Sub1' do |s|" \
      "\n\t\ts.source_files = [\"SourceCode/**/*.{swift}\", \"SourceCode/**/*.{h}\"]" \
      "\n\t\ts.dependency 'SDependency'"\
      "\n\tend" \
      "\n" \
      "\nend"
  }

  context 'attributes are set' do
    it 'returns generated line' do
      info = described_class.new
      info.author = { 'Name' => 'email' }
      info.name = "Name"
      info.version = "Version"
      info.summary = "Summary"
      info.description = "Description"
      info.homepage = "Homepage"
      info.license = { type: 'MIT', file: 'LICENSE' }
      info.platform = %w[ios 13.0]
      info.swift_version = "5.9"
      info.source = { http: 'my url' }
      info.static_framework = true
      info.source_files = 'SourceCode/**/*.{swift}', 'SourceCode/**/*.{h}'
      info.add_dependency("Dependency1")
      info.add_dependency("Dependency2","1.0.0")
      info.add_subspec("Sub1",
                       ['SourceCode/**/*.{swift}', 'SourceCode/**/*.{h}'],
                       [{ name: "SDependency" }]
                      )
      expect(info.build_pod_spec_string).to eq(expected_settings_string)


    end

  end
end
