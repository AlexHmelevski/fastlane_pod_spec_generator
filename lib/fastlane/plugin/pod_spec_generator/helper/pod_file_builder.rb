# frozen_string_literal: true

class PodFileBuilder
  attr_writer :use_frameworks,
              :targets,
              :apply_local_spm_fix

  def initialize
    @use_frameworks = true
    @targets = []
    @apply_local_spm_fix = false
  end

  def build_pod_file_string
    [use_frameworks_string,
     apply_local_spm_fix_string,
     targets_string,
    ].compact
     .join("\n")
  end

  private

  def targets_string
    @targets.reduce("") do |str, target|
      str += "#{create_target_string(target)}\n"
    end
  end

  def create_target_string(target)
    start = "target '#{target[:name]}' do"
    dependencies = target[:dependencies].map do |dependency|
      "\t#{create_dependencies_string(dependency)}\n"
    end
    [start, dependencies, "end"].join("\n")
  end

  def create_dependencies_string(dependency)
    start = "pod '#{dependency[:name]}'"
    [start, dependency[:version]].compact.join(", ")
  end

  def apply_local_spm_fix_string
    return "plugin 'fastlane-plugin-pod_spec_generator'" if @apply_local_spm_fix
    return nil
  end
  def use_frameworks_string
    return "use_frameworks!" if @use_frameworks

    return nil
  end
end
