
def environment
	super
	
	require 'active_record/migrations/tasks'
	
	# The root must be the root of your application, and contain `db/`.
	ActiveRecord::Migrations.root = context.root
end
