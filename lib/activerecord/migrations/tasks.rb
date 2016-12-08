
require_relative 'tasks/db'
require_relative 'tasks/db/migrations'

module ActiveRecord
	module Migrations
		class << self
			attr_accessor :root
		end
		
		def self.database?
			!ActiveRecord::Base.connection.data_sources.empty?
		rescue ActiveRecord::NoDatabaseError
			false
		end
	end
end
