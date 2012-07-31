class Cretenewsers
	attr_accessor :sname, :mail 					#create attribute accessors corresponding to a user's name and email

	def initialize(attributes = {}) 				#initialize is a special method in ruby and used as a constructor
		@sname = attributes[:sname] 					#instance variables automatically available in views and are used when you want the to be available in all ruby class
		@mail = attributes[:mail] 				#instance variables
	end

	def formatted_email 							#this a method that uses values assigned to our instance variables to build a nice formatted version of user's email address.
		"#{@sname} <#{@mail}>"
	end
end