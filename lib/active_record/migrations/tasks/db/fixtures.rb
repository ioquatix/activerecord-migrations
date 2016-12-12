
namespace :db do
	namespace :fixtures do
		task :tables => :environment do
			all_tables = ActiveRecord::Base.connection.tables
			
			if tables_string = ENV['TABLES']
				@tables = tables_string.split(',')
			else
				# We skip update/event tables since these contain a lot of non-critical data.
				@tables = all_tables.grep_v(/.*?(_update|_event|_notification)/)
			end
			
			puts "Dumping Tables: #{@tables.join(', ')}"
			puts "Skipping Tables: #{(all_tables - @tables).join(', ')}"
		end
		
		desc 'Create YAML fixtures from data in an existing database.'
		task :dump => :tables do
			sql  = "SELECT * FROM %s"
			
			root = ENV.fetch('FIXTURES_PATH') {ActiveRecord::Tasks::DatabaseTasks.fixtures_path}
			FileUtils.mkpath root
			
			@tables.each do |table_name|
				fixture_path = "#{root}/#{table_name}.yml"
				
				puts "Dumping #{table_name} to #{fixture_path}..."
				
				i = "000"
				
				File.open(fixture_path, 'w') do |file|
					data = ActiveRecord::Base.connection.select_all(sql % table_name)
					file.write data.inject({}) { |hash, record|
						hash["#{table_name}_#{i.succ!}"] = record
						hash
					}.to_yaml
				end
			end
		end
	end
end