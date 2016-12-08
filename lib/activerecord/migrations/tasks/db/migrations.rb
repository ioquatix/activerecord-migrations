
namespace :db do
	namespace :migrations do
		desc "Creates a new migration file with the specified name"
		task :new, :name, :options do |t, args|
			unless name = args[:name] || ENV['name']
				abort "You must provide a name of the migration to generate"
			end
			
			if options = args[:options] || ENV['options']
				options = options.split('/')
			else
				options = []
			end
			
			require "rails/generators"
			
			parameters = [name] + options
			Rails::Generators.invoke "active_record:migration", parameters, :destination_root => ActiveRecord::Migrations.root
		end
	end
end
