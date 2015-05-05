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

	# Precond:
	# Book is a valid book object as defined in book.rb
	# Postcond:
	# the books contents are added to the assoc network
	def readBook book, debug=nil
		content = book.processedContents
		count = 0
		content.each do |items|
			@assocNet.createConnections(items)
			count += 1 if debug
		end
	end

	# Precond:
	# query is a valid GenCase object
	# Postcond:
	# returns the most similar case as determined by SID
	def findSimilarCase query
		return nil if @case.size == 0
		bestCase = @cases[0]
		bestSimilarity = query.sidSimilarity(@cases[0],@assocNet,@assocNet.avgConnectionSID*10)
		@cases.each_index do |i|
			next if i == 0
			sim = query.sidSimilarity(@cases[i],@assocNet,@assocNet.avgConnectionSID*10)
			if(sim > bestSimilarity)
				bestCase = @cases[i]
				bestSimilarity = sim
			end
		end
		return bestCase
	end

	private

	# Precond:
	# filename is a valid string
	#  which names a file that adheres to the format of a case library file
	# Postcond:
	# adds the cases to both the case library and the association network
	def parseFile filename
		fin = File.new(filename, 'r')
		contents = fin.read
		fin.close
		contents = contents.split("\n")
		contents.map!{|l| l.strip.upcase}
		contents = contents.join("\n")
		contents = contents.split("BEGIN-CASE")
		contents.map!{|c| c.split("\n")}
		currentCase = GenCase.new
		contents.each do |c|
			c.each do |attribute|
				next if attribute == '' || attribute == 'BEGIN-CASE'
				sides = attribute.split('-')
				next if side.size != 2
				attrName = side[0]
				attrVals = side[1].split(',')
				currentCase.addAttribute(attrName, attrVals)
			end
			@case.push(currentCase.clone)
		end
		@assocNet.addCaseLibrary(@cases)
	end

end