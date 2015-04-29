require_relative 'association_network'

class Reasoner
	attr_reader :cases

	# Precond:
	# None
	# Postcond:
	# Creates a new reasoner with an empty assoc network
	# and an empty case library
	def initialize
		@cases = []
		@assocNet = AssocNetwork.new
	end

	# Precond:
	# filename is a valid file which adheres to the format of a case library file
	# Postcond:
	# adds the cases to both the case library and the association network
	def loadCasesFromFile filename
		parseFile(filename)
	end

	private

	# Precond:
	# filename is a valid string
	#  which names a file that adheres to the format of a case library file
	# Postcond:
	# adds the cases to both the case library and the association network
	def parseFile filename
	end
end