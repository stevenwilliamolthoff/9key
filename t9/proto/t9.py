from keyTrie import *
from cache import *
from sets import Set
 
# Sources:
# http://www.mitchrobb.com/t9-in-javascript-with-a-prefix-tree/
# https://leetcode.com/articles/implement-trie-prefix-tree/

class Uppers:
	def __init__(self, index):
		self.index = index
	def getIndex(self):
		return self.index

def suggester(trie, cache, numResults, numCacheResults, keySequence, suggestionDepth, uppers):
	suggestions = []
	numTrieSuggestions = numResults - numCacheResults
	trieSuggestions = trie.__getSuggestions__(keySequence, suggestionDepth)
	for t in trieSuggestions[:numTrieSuggestions]:
		if not t in suggestions:
			suggestions.append(t)
	if len(suggestions) < numResults:
		cacheSuggestions = cache.cacheTrie.getSuggestions(keySequence, suggestionDepth)
		for t in cacheSuggestions[:numResults - numTrieSuggestions]:
			if not t in suggestions:
				suggestions.append(t)
		for i, s in enumerate(suggestions):
			newWord = s
			for u in uppers:
				newWord = newWord[:u.getIndex()] + newWord[u.getIndex()].upper() + newWord[u.getIndex() + 1:]
			suggestions[i] = newWord
	return suggestions

def texter(T, suggestionDepth, cacheSize, numResults, numCacheResults):
	cache = Cache(cacheSize)
	cmdline = raw_input("> ")
	word = ""
	originalWord = ""
	while cmdline != "reset()" and cmdline != "quit()":
		cmdline = cmdline.replace(' ', '')
		#cmdline = cmdline.lower()
		cmdline = cmdline.translate(None, string.punctuation)
		predictionSuccessful = False
		uppers = []
		for c in cmdline:
			suggestions = Set()
			word += c
			originalWord += c
			
			if c in string.ascii_uppercase:
				uppers.append(Uppers(len(word) - 1))
			
			word = word.lower()
			
			keySeq = getKeySequence(word)
			print "Key sequence:", keySeq
			print "Suggestion for string:", originalWord
			suggestions = suggester(T, cache, numResults, numCacheResults, keySeq, suggestionDepth, uppers)
			print suggestions
			for s in suggestions:
				if s == cmdline:
					print "Word successfully predicted after", len(word), "chars typed."
					predictionSuccessful = True
			if predictionSuccessful:
				break
		if not predictionSuccessful:
			print "Failed to predict word."
		word = cmdline.lower()
		keySeq = getKeySequence(word)
		newFreq = T.updateFrequency(word, keySeq)
		cache.update(word, newFreq, keySeq)
		print "--------------------"
		cmdline = raw_input("> ")
		word = ""
		originalWord = ""
	print "Exiting..."
	if cmdline == "reset()":
		T.resetDictionary("freqDictOriginal.txt")
		
def main():
	print "----------T9 Prototype----------"
	print "Enter a word. A list of word predictions will be printed as each letter is read."
	print "Predictions are returned in an order - by shortest valid words, and then by weight, and then in the same ranking for words in the cache."
	print "Currently, no punctuation, no numbers, etc. are supported."
	print "Type 'reset() to quit without saving changes to dictionary."
	print "Type 'quit() to quit and save."
	print "1:         | 2: A B C | 3: D E F"
	print "4: G H I   | 5: J K L | 6: M N O"
	print "7: P Q R S | 8: T U V | 9: W X Y Z"
	suggestionDepth = 10
	numResults = 20
	cacheSize = 20
	numCacheResults = 10
	filename = "freqDict.txt"
	T = Trie(filename)
	T.loadTrie(filename)
	texter(T, suggestionDepth, cacheSize, numResults, numCacheResults)
	print ('|')
		
if __name__ == '__main__':
	main()