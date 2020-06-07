
require_relative "lib/active_record/migrations/version"

Gem::Specification.new do |spec|
	spec.name = "activerecord-migrations"
	spec.version = ActiveRecord::Migrations::VERSION
	
	spec.summary = "Provides a opinionated migration wrapper for ActiveRecord 5+"
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/ioquatix/activerecord-migrations"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{bake,lib}/**/*', File::FNM_DOTMATCH, base: __dir__)

	spec.required_ruby_version = ">= 0"
	
	spec.add_dependency "activerecord", [">= 5", "< 7"]
	spec.add_dependency "railties"
	spec.add_dependency "rainbow", "~> 2.0"
	
	spec.add_development_dependency "bake-bundler"
	spec.add_development_dependency "bake-modernize"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
