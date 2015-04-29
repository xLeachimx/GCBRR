class NetworkNode
	attr_reader :name
	attr_reader :connections
	attr_reader :activated

	# Precond:
	# name is a valid string or symbol
	# Postcond:
	# creates a new NetworkNode which has no connections and whose name is name and has not been activated
	def initialize name
		@name = name
		@connections = {}
		@activated = nil
	end

	# Precond:
	# node is a valid NetworkNode
	# Postcond:
	# the node now has a connection to the specified node
	def addConnection node
		@connections[node.name] = [1,node]
	end

	# Precond:
	# name is the name of a node
	# to is the resultant value of the connection strength
	# Postcond:
	# The connection to the node specified by name is now equal to to
	def changeConnectionStr name, to
		@connections[name][0] = to 
	end

	# Precond:
	# name is the name of a node
	# Postcond:
	# returns the strength of the connetion to the node with name name
	def getConnectionStr name
		return @connections[name][0]
	end

	# Precond:
	# to is a valid NetworkNode
	# Postcond:
	# returns true iff the node is connected to a node with the same name
	def isConnected to
		return @connections[to.name] != nil
	end

	# Precond:
	# level is some object
	# Postcond:
	# activated is set to level
	def activate level
		@activated = level
	end

	# Precond:
	# Postcond:
	# sets activated to nil
	def deactivate
		@activated = nil
	end

end

class AssocNetwork
	attr_reader :nodes
	attr_reader :strongestConnection

	# Precond:
	# none
	# Postcond:
	# creates a blank association network
	def initialize
		@nodes = {}
		@strongestConnection = 0
	end

	# Precond:
	# name is a valid string or symbol
	# Postcond:
	# returns true iff a node with name exists in the network
	def nodeExists name
		return @nodes[name] != nil
	end

	# Precond:
	# name is a valid symbol or string
	# Postcond:
	# Creates a new node which has the name specified
	def newNode name
		@nodes[name] = NetworkNode.new(name)
	end

	# Precond:
	# activationLevel is an integer
	# item1 is the name of a node in the network
	# item2 is the name of a node in the network
	# Postcond:
	# Returns the activation level of items2 
	def similarityQuery activationLevel, item1, item2
		return activationLevel if item1 == item2
		prepSid
		sid(activationLevel,item1)
		result = @nodes[item2].activated
		result = 0 if result == nil
		return result
	end

	# Precond:
	# creates connection based on a series of symbols and/or strings in items
	# Postcond:
	# Adds connections to the network based on the contents of items.
	def createConnections items
		items = items.uniq
		items.each do |item|
			if !nodeExists(item)
				newNode(item)
			end
		end

		items.combination(2) do |pair|
			# exstablish a connection if none
			# assuming a connection is there increment the strength
			# if needed set the strongest connection variable
			if @nodes[pair[0]].isConnected(pair[1])
				increment = @nodes[pair[0]].getConnectionStr(pair[1]) + 1
				if increment > @strongestConnection
					@strongestConnection = increment
				end
				@nodes[pair[0]].changeConnectionStr(pair[1],increment)
			else
				@nodes[pair[0]].addConnection(pair[1])
			end

			if @nodes[pair[1]].isConnected(pair[0])
				increment = @nodes[pair[1]].getConnectionStr(pair[0]) + 1
				if increment > @strongestConnection
					@strongestConnection = increment
				end
				@nodes[pair[1]].changeConnectionStr(pair[0],increment)
			else
				@nodes[pair[1]].addConnection(pair[0])
			end
		end
	end

	# Precond:
	# cases is an array of GenCase objects as defined in generic_case.rb
	# Postcond:
	# adds to the association network the entire case library given
	def addCaseLibrary cases
		cases.each do |c|
			addCase(c)
		end
	end


	private

	# Precond:
	# None
	# Postcond:
	# all nodes become deactivated
	def prepSid
		@nodes.each_value{|n| n.deactivate}
	end

	# Precond:
	# location is a node name where sid currently is
	# currentActivation is the current activation level of the system
	# Postcond:
	# the network becomes activated
	def sid currentActivation, location
		return if currentActivation <= 0
		return if @nodes[location].activated != nil && @nodes[location].activated >= currentActivation
		@nodes[location].activate(currentActivation)
		@nodes[location].connections.each do |connection|
			activationLoss = @strongestConnection - connection[0] + 1
			nextActivation = currentActivation - activationLoss
			sid(nextActivation, connection[1].name)
		end
	end

	# Precond:
	# c is a GenCase object as defined in generic_case.rb
	# Postcond:
	# adds to the association network the case given
	def addCase c
		overall = []
		c.attributes.each_value do |vals|
			createConnections(vals)
			overall += vals
		end
		createConnections(overall)
	end
end