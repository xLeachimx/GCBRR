class GenCase
	attr_reader :designation
	attr_reader :attributes

	# Precond:
	# None
	# Postcond:
	# creates a new GenCase with the specfied designation
	def initialize designation
		@designation = designation
	end

	# Precond:
	# attrName is the name of the attribute(either string or symbol)
	# attrValues is an array of strings(or symbols)
	# 	which represent the values of the attribute
	# Postcond:
	# adds the attribute and value to the attributes of the case
	def addAttribute attrName, attrValues
		@attributes[attrName] = attrValues
	end

	# Precond:
	# otherCase is a valid GenCase object
	# Postcond:
	# simply counts the occurances which the two cases share
	# reports these by returning an integer
	def simpleCountSimilarity otherCase
		count = 0
		@attributes.each do |key, value|
			otherCase.attributes.each do |key2, value2|
				if key == key2
					value.each do |item|
						count += 1 if value2.include?(item)
					end
				end
			end
		end
		return count
	end

	# Precond:
	# otherCase is a valid GenCase object
	# network is a valid instance of AssocNetwork
	# level is the initial activation for the SID
	# Postcond:
	# uses semantic index distance with the specified AssocNetwork
	def sidSimilarity otherCase, network, level
		totalSimilarity = 0
		@attributes.each do |key, value|
			if otherCase.attributes[key] != nil
				value.each do |item|
					otherCase.attributes[key].each do |item2|
						initialActivation = level/value.size()
						totalSimilarity += network.similarityQuery(initialActivation,item,item2)/otherCase.attributes[key].size
					end
				end
			end
		end
		return totalSimilarity
	end
end