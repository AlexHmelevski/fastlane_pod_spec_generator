# frozen_string_literal: true
require 'cocoapods'
class Pod::Specification
  SPM_DEPENDENCIES_BY_POD = {}
  LOCAL_SPM_DEPENDENCIES_BY_POD = {}
  def spm_dependency(url:, requirement:, products:)
    @spm_dependencies ||= []
    @spm_dependencies << { url: url, requirement: requirement, products: products }
    SPM_DEPENDENCIES_BY_POD[self.name] = @spm_dependencies
  end

  def local_spm_dependency(path:, products:)
    puts "local dependency #{path}"
    @local_spm_dependencies ||= []
    @local_spm_dependencies << { path: path, products: products}
    LOCAL_SPM_DEPENDENCIES_BY_POD[self.name] = @local_spm_dependencies
  end
end
