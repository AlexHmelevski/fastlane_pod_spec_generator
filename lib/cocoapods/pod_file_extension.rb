# frozen_string_literal: true
require 'cocoapods'

class Pod::Podfile
  alias original_post_install! post_install!
  def post_install!(installer)
    puts "post_install! #{self}"
    project = installer.pods_project
    clean_spm_dependencies_from_target(project)
    install_remote_spm_dependencies(project)
    install_local_spm_dependencies(project)
    run_swift_fix_for_project(project)
    original_post_install!(installer)
  end

  private
  def add_local_spm_to_target(project, target, path, products)
    loc_pkg_class = Xcodeproj::Project::Object::XCLocalSwiftPackageReference
    ref_class = Xcodeproj::Project::Object::XCSwiftPackageProductDependency
    pkg = project.root_object.package_references.find { |p| p.class == loc_pkg_class && p.path == path }

    unless pkg
      pkg = project.new(loc_pkg_class)
      pkg.relative_path = path
      project.root_object.package_references << pkg
    end
    products.each do |product_name|
      ref = target.package_product_dependencies.find do |r|
        r.class == ref_class && r.package == pkg && r.product_name == product_name
      end
      next if ref

      ref = project.new(ref_class)
      ref.package = pkg
      ref.product_name = product_name
      target.package_product_dependencies << ref
    end
  end

  def add_spm_to_target(project, target, url, requirement, products)
    pkg_class = Xcodeproj::Project::Object::XCRemoteSwiftPackageReference
    ref_class = Xcodeproj::Project::Object::XCSwiftPackageProductDependency
    pkg = project.root_object.package_references.find { |p| p.class == pkg_class && p.repositoryURL == url }

    if !pkg
      pkg = project.new(pkg_class)
      pkg.repositoryURL = url
      pkg.requirement = requirement
      project.root_object.package_references << pkg
    end
    products.each do |product_name|
      ref = target.package_product_dependencies.find do |r|
        r.class == ref_class && r.package == pkg && r.product_name == product_name
      end
      next if ref

      ref = project.new(ref_class)
      ref.package = pkg
      ref.product_name = product_name
      target.package_product_dependencies << ref
    end
  end

  def clean_spm_dependencies_from_target(project)
    project.root_object.package_references.delete_if { |pkg| pkg.class == Xcodeproj::Project::Object::XCRemoteSwiftPackageReference }
  end

  def install_local_spm_dependencies(project)
    puts "installing local dependencies"
    Pod::Specification::LOCAL_SPM_DEPENDENCIES_BY_POD.each do |pod_name, dependencies|
      dependencies.each do |spm_spec|
        puts "installing #{spm_spec[:path]}, #{spm_spec[:products]}"
        add_local_spm_to_target(
          project,
          project.targets.find { |t| t.name == pod_name},
          spm_spec[:path],
          spm_spec[:products]
        )
      end
    end
  end

  def install_remote_spm_dependencies(project)
    Pod::Specification::SPM_DEPENDENCIES_BY_POD.each do |pod_name, dependencies|
      dependencies.each do |spm_spec|
        add_spm_to_target(
          project,
          project.targets.find { |t| t.name == pod_name},
          spm_spec[:url],
          spm_spec[:requirement],
          spm_spec[:products]
        )
      end
    end
  end

  def run_swift_fix_for_project(project)
    Pod::Specification::LOCAL_SPM_DEPENDENCIES_BY_POD.merge(Pod::Specification::SPM_DEPENDENCIES_BY_POD).each do |pod_name, dependencies|
      target = project.targets.find { |t| t.name == pod_name}
      target.build_configurations.each do |config|
        target.build_settings(config.name)['SWIFT_INCLUDE_PATHS'] ||= ['$(inherited)']
        search_path = '${SYMROOT}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/'
        unless target.build_settings(config.name)['SWIFT_INCLUDE_PATHS'].include?(search_path)
          target.build_settings(config.name)['SWIFT_INCLUDE_PATHS'].push(search_path)
        end
      end
    end
  end
end

# class Pod::Podfile
#   prepend PodFileExtension
# end