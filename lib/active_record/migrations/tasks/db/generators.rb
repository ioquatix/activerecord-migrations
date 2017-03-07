
require 'rails/generators'

if ActiveRecord::version >= Gem::Version.new("5.0.2")
	# This is a monkey patch to work around the flakey design of ActiveRecord migrations.
	require 'rails/generators/active_record/migration/migration_generator'

	class ::ActiveRecord::Generators::MigrationGenerator
		def db_migrate_path
			ActiveRecord::Migrations.migrations_root
		end
	end
end
