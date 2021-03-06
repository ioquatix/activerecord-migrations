# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'tasks/db'

module ActiveRecord
	module Migrations
		class << self
			attr_accessor :root
			
			def migrations_root
				File.join(self.root, 'db/migrate')
			end
		end
		
		def self.database?
			!ActiveRecord::Base.connection.data_sources.empty?
		rescue ActiveRecord::NoDatabaseError
			false
		end
	end
	
	if defined? Tasks::DatabaseTasks
		module Tasks
			module DatabaseTasks
				def each_current_configuration(environment, spec_name = nil)
					unless configuration = ActiveRecord::Base.configurations[environment]
						raise ArgumentError.new("Cannot find configuration for environment #{environment.inspect} in #{ActiveRecord::Base.configurations.keys}")
					end
					
					# This is a hack because DatabaseTasks functionality uses string for keys.
					yield configuration.stringify_keys
				end
			end
		end
	end
end
