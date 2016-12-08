
namespace :db do
	task :load_config => :environment do
		database_tasks = ActiveRecord::Tasks::DatabaseTasks
		
		unless root = ActiveRecord::Migrations.root
			abort "ActiveRecord::Migrations.root needs to be set!"
		end
		
		unless DATABASE_ENV
			abort "DATABASE_ENV needs to be set!"
		end
		
		if ActiveRecord::Base.configurations.empty?
			abort "ActiveRecord::Base.configurations needs to be setup!"
		end
		
		database_tasks.root = root
		database_tasks.db_dir = File.join(root, 'db')
		database_tasks.env = DATABASE_ENV.to_s
		database_tasks.database_configuration = ActiveRecord::Base.configurations
		database_tasks.migrations_paths = File.join(root, 'db/migrate')
		
		database_tasks.send(:define_method, :load_seed) do
			load File.join(root, 'db/seed.rb')
		end
	end
	
	task 'Setup a new database if required and run migrations.'
	task :deploy => :load_config do
		database_tasks = ActiveRecord::Tasks::DatabaseTasks
		
		schema_path = File.join(database_tasks.db_dir, 'schema.rb')
		unless File.exist? schema_path
			abort "Missing #{schema_path}, cannot deploy!"
		end
		
		if ActiveRecord::Migrations.database?
			Rake::Task['db:migrate'].invoke
		else
			Rake::Task['db:setup'].invoke
		end
	end
	
	task :connection_config => :environment do
		require 'pp'
		
		pp ActiveRecord::Base.connection_config
	end
end

# Loading this AFTER we define our own load_config task is critical, we need to make sure things are set up correctly before we run the task of the same name from ActiveRecord.
load 'active_record/railties/databases.rake'
