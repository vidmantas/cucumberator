# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cucumberator/version"

Gem::Specification.new do |s|
  s.name        = "cucumberator"
  s.version     = Cucumberator::VERSION
  s.authors     = ["Vidmantas Kabošis"]
  s.email       = ["vidmantas@kabosis.lt"]
  s.homepage    = "https://github.com/vidmantas/cucumberator"
  s.summary     = "cucumberator-#{s.version}"
  s.description = %q{Prompt for writing Cucumber tests}
  s.post_install_message = "(::)\nCucumberator installed! Now require cucumberator in your env.rb and check README for usage examples\n(::)"
  s.licenses    = ['MIT', 'GPL-2']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency 'cucumber', '> 1.3'

  s.add_development_dependency 'aruba', '~> 0.5.3'
  s.add_development_dependency 'pry'
end
