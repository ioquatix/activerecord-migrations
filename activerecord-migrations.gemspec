# coding: utf-8
require_relative 'lib/active_record/migrations/version'

Gem::Specification.new do |spec|
	spec.name          = "activerecord-migrations"
	spec.version       = ActiveRecord::Migrations::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = %q{Provides a opinionated migration wrapper for ActiveRecord 5+}
	spec.homepage      = "https://github.com/ioquatix/activerecord-migrations"
	spec.license       = "MIT"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	spec.bindir        = "exe"
	spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	spec.add_dependency "activerecord", "~> 5.0"
	spec.add_dependency "railties", "~> 5.0"

	spec.add_development_dependency "bundler", "~> 1.13"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
