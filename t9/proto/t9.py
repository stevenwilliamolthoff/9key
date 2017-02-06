from keyTrie import *
from cache import *
from sets import Set
 
# Sources:
# http://www.mitchrobb.com/t9-in-javascript-with-a-prefix-tree/
# https://leetcode.com/articles/implement-trie-prefix-tree/

def suggester(trie, cache, numResults, numCacheResults, keySequence, suggestionDepth):
	suggestions = Set()
	numTrieSuggestions = numResults - numCacheResults
	trieSuggestions = trie.__getSuggestions__(keySequence, suggestionDepth)
	for t in trieSuggestions[:numTrieSuggestions]:
		suggestions.add(t)
	if len(suggestions) < numResults:
		cacheSuggestions = cache.cacheTrie.getSuggestions(keySequence, suggestionDepth)
		for t in cacheSuggestions[:numResults - numTrieSuggestions]:
			suggestions.add(t)
	return suggestions

def texter(T, suggestionDepth, cacheSize, numResults, numCacheResults):
	cache = Cache(cacheSize)
	cmdline = raw_input("> ")
	word = ""
	while cmdline != "reset()" and cmdline != "quit()":
		cmdline = cmdline.replace(' ', '')
		cmdline = cmdline.lower()
		cmdline = cmdline.translate(None, string.punctuation)
		predictionSuccessful = False
		for c in cmdline:
			suggestions = Set()
			word += c
			keySeq = getKeySequence(word)
			print "Key sequence:", keySeq
			print "Suggestion for string:", word
			suggestions = suggester(T, cache, numResults, numCacheResults, keySeq, suggestionDepth)
			suggestionsStr = ''
			for s in suggestions:
				suggestionsStr += s + ' '
			print suggestionsStr
			for s in suggestions:
				if s == cmdline:
					print "Word successfully predicted after", len(word), "chars typed."
					predictionSuccessful = True
			if predictionSuccessful:
				break
		if not predictionSuccessful:
			print "Failed to predict word."
		word = cmdline
		keySeq = getKeySequence(word)
		newFreq = T.updateFrequency(word, keySeq)
		cache.update(word, newFreq, keySeq)
		print "--------------------"
		cmdline = raw_input("> ")
		word = ""
	print "Exiting..."
	if cmdline == "reset()":
		T.resetDictionary("freqDictOriginal.txt")
		
def main():
	print "----------T9 Prototype----------"
	print "Enter a word. A list of word predictions will be printed as each letter is read."
	print "Predictions are returned in an order - by shortest valid words, and then and by an estimated frequency of use."
	print "Currently, only lower-case ascii chars are supported. No capitals, no spaces or punctuation, no numbers, etc. Will be coming."
	print "Type 'reset() to quit without saving changes to dictionary."
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