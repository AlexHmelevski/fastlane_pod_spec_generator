# frozen_string_literal: true
require 'fastlane/actions/cocoapods'
class PodSpecBuilder
  attr_writer :version,
              :summary,
              :author,
              :license,
              :description,
              :homepage,
              :platform,
              :name,
              :subspecs,
              :swift_version,
              :source_files,
              :resources,
              :source,
              :dependencies,
              :spm_local_dependencies,
              :static_framework,
              :vendored_frameworks


  def initialize
    @version = nil
    @summary = nil
    @author = nil
    @homepage = nil
    @platform = nil
    @name = nil
    @dependencies = []
    @subscpecs = []
    @resources = nil
    @source = nil
    @source_files = nil
    @swift_version = nil
    @source_files = nil
    @source = nil
    @spm_local_dependencies = []
    @static_framework = false
    @vendored_frameworks = nil
  end

  def build_pod_spec_string
    [start_of_spec,
     podspec_content_setting_string,
     static_framework_string,
     vendored_frameworks_string,
     generate_dependencies(@dependencies),
     subscpecs_string,
     generate_local_spm_dependencies(@spm_local_dependencies),
     end_of_spec
    ].compact.reject { |s| s.empty? }.join("\n")
  end

  def add_dependency(name, version = nil)
    @dependencies.append({:name=>name, :version=>version})
  end

  def add_subspec(name, local_files, dependencies)
    @subscpecs.append({
                        name:,
                        local_files:,
                        dependencies:
                      })
  end

  private

  def podspec_content_setting_string
    to_hash.sort.map   do  |k, v|
      if v.is_a?(String)
        "\ts.#{k} = '#{v}'"
      else
        "\ts.#{k} = #{v}"
      end

   end
   .join("\n")
  end
  def to_hash
    hash = {}
    instance_variables.reject { |var| exclude(var) }
                      .each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash.compact.reject { |_k, v| v.empty? }
  end

  def static_framework_string
    return "\ts.static_framework = true" if @static_framework
    nil
  end

  def vendored_frameworks_string
    return "\ts.ios.vendored_frameworks = '#{@vendored_frameworks}'" if @vendored_frameworks
    nil
  end
  def exclude(variable)
    %w[@subscpecs @dependencies @spm_local_dependencies @static_framework @vendored_frameworks].include? variable.to_s
  end
  def content(items)
    items.reject(&:empty?).reduce(String.new) do |content, item|
      content += "#{item}\n"
    end
  end

  def subscpecs_string
    @subscpecs.reduce(String.new) do |content, subscpec|
      content += "#{subspec_string(subscpec)}\n"
    end
  end

  def subspec_string(sub)
    "\n\ts.subspec '#{sub[:name]}' do |s|"\
    "\n\t\ts.source_files = #{sub[:local_files]}#{generate_dependencies(sub[:dependencies],"\t")}" \
    "\n\tend"
  end

  def generate_dependencies(dependencies, allignment = "")
    dependencies.reduce(String.new) do |content, dep|
      dependency = "\n#{allignment}\ts.dependency '#{dep[:name]}'"
      vers = dep[:version] ? "#{dep[:version]}" : nil
      out = [dependency, vers].compact.join(", ")
      content += "#{out}"
    end
  end

  def generate_local_spm_dependencies(dependencies)
    dependencies.reduce(String.new) do |content, dep|
      dependency = "\n\ts.local_spm_dependency(path: '#{dep[:path]}', products: #{dep[:products]})"
      content += "#{dependency}"
    end
  end

  def start_of_spec
    "Pod::Spec.new do |s|"
  end

  def end_of_spec
    "end"
  end
end
