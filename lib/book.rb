class Book
	attr_reader :filename

	# Precond:
	# filename is the name of a plaintext file
	# Postcond:
	# creates new book object
	def initialize filename
		@filename = filename
	end

	# Precond:
	# The book is initialized with a good filename
	# Postcond:
	# returns the contents of the file as if doing a read
	def contents
		fin = File.new(@filename,'r')
		c = fin.read
		fin.close
		return c
	end

	# Precond:
	# The objects is properly initialized
	# Postcond:
	# Returns contents as an array of arrays thati
	#  is perfect for feeding into an assoc network
	def processedContents
		moded = contents()
		moded = moded.split("\n")
		moded.delete_if{|l| l==''}
		moded.map!{|l| removeQuotesAndPunc(l)}
		moded.map!{|l| l.split(" ")}
		moded.map!{|l| removeBlackList(l)}
		return moded
	end

	private

	# Precond:
	# words is an array of strings
	# Postcond:
	# removes all strings that are part of a black list
	# returns a modified list
	def removeBlackList words
		blacklist = ['a','an','the','then','but','therefore','because','I','he',
					 'she','it','him','her','his','her','its','they','them','their']
		blacklist.map!{|w| w.upcase}
		modified = words.clone
		modified.delete_if{|w| blacklist.include?(w.upcase)}
		return modified
	end

	# Precond:
	# sentence is a valid string
	# Postcond:
	# Removes the quotations and puncuation in the sentence and returns it
	def removeQuotesAndPunc sentence
		quotes = ["\"","'",":",",",".","(",")",";","!","&","<",">","?","-","_"]
		words = sentence.split(' ')
		words.map! do |w|
			w.slice!(1) if quotes.include?(w[0])
			w.slice(-1) if quotes.include?(w[-1])
			w
		end
		return words.join(' ')
	end
end