
def deploy
	call('activerecord:environment')
	
	Rake::Task['db:deploy'].invoke
end
