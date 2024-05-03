describe Fastlane::Actions::PodSpecGeneratorAction do

  let(:sut) { Fastlane::Actions::PodSpecGeneratorAction }
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
      "\n\ts.vendored_frameworks = 'Framework'"\
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

    it 'Generates podfile' do

      sut.run({
                author: { "Name" => "email" },
                version: "Version",
                description: "Description",
                summary: "Summary",
                name: "Name",
                license: { type: "MIT", file: "LICENSE" },
                folder: folder_path,
                swift_version: "5.9",
                homepage: "Homepage",
                source: {:http=>"my url"},
                platform: {:ios=>"13.0"},
                source_files: %w[SourceCode/**/*.{swift} SourceCode/**/*.{h}],
                dependencies: [
                  { name: "Dependency1" },
                  { name: "Dependency2", version: "1.0.0" }
                ],
                spm_local_dependencies: [
                  {path: "mypath", products: ["SPM1"]}
                ],
                vendored_frameworks: "Framework"
      })
      expect(read_file_data).to eq(expected_settings_string)
    end
  end

  def read_file_data
    File.read("#{folder_path}/Name.podspec")
  end
end
