require_relative 'lib/reasoner'
require_relative 'lib/book'

agustus = Reasoner.new('Agustus')

def train
	books = ['52dinners.txt','thingsMother.txt','triedtrue.txt','wilson.txt']
	books.map!{|b| Book.new('books/' + b)}
	books.each do |b|
		agustus.readBook(b)
	end
end

train
agustus.saveReasoner