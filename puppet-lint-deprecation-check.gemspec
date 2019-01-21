Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-deprecation-check'
  spec.version     = '0.1.0'
  spec.homepage    = 'https://github.com/ragnarkon/puppet-lint-deprecation-check'
  spec.license     = 'MIT'
  spec.author      = 'Bryan Woolsey'
  spec.email       = 'ragnarkon@gmail.com'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'puppet-lint deprecation check'
  spec.description = 'A puppet-lint plugin to check for common deprecated Puppet artifacts'

  spec.add_dependency             'puppet-lint', '>= 1.0', '< 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
end
