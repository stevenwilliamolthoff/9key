from keyTrie import *
from cache import *
 
# Sources:
# http://www.mitchrobb.com/t9-in-javascript-with-a-prefix-tree/
# https://leetcode.com/articles/implement-trie-prefix-tree/

def suggester(trie, cache, numResults, numCacheResults, keySequence, suggestionDepth, uppers):
	# holds the list of predicted words
	suggestions = []
	
	# the number of suggestions to take from the Trie.
	numTrieSuggestions = numResults - numCacheResults
	
	# get suggestions from the Trie
	trieSuggestions = trie.__getSuggestions__(keySequence, suggestionDepth)
	
	# add trie suggestions to list
	for t in trieSuggestions[:numTrieSuggestions]:
		suggestions.append(t)
	
	# if there is still room for more suggestions, add some from the cache
	if len(suggestions) < numResults:
		cacheSuggestions = cache.cacheTrie.getSuggestions(keySequence, suggestionDepth)
		
		# Only add cache suggestions that are not already in the suggestions list
		cacheSuggestionCount = 0
		cacheIndex = 0
		while (cacheSuggestionCount < (numResults - numTrieSuggestions)) and (cacheIndex < len(cacheSuggestions)):
			if not cacheSuggestions[cacheIndex] in suggestions:
				suggestions.append(cacheSuggestions[cacheIndex])
				cacheSuggestionCount += 1
			cacheIndex += 1
			
	# the user entered uppercase letters, capitalize the suggestions appropriately
	if len(uppers) > 0:
		for i, s in enumerate(suggestions):
			newWord = s
			for u in uppers:
				newWord = newWord[:u] + newWord[u].upper() + newWord[u + 1:]
			suggestions[i] = newWord
	return suggestions

def texter(filename, filenameOriginal, trie, suggestionDepth, cacheSize, numResults, numCacheResults):
	# create a Cache object
	cache = Cache(cacheSize)
	
	# get user input
	rawUserInput = raw_input("> ")
	
	# For this texting simulator, you type in a whole word, but the program
	# reads in one letter at a time, suggesting words at each progressively
	# longer string. e.g. Typing in "hello", the program will give suggestions
	# for "h", and then for "he", and so on.
	wordTypedSoFarLowercase = ""
	
	# holds the original word typed. retains capital letters.
	wordTypedSoFarOriginalCase = ""
	
	# while the user is still texting.
	while rawUserInput != "reset()" and rawUserInput != "quit()":
		
		# strip user input of spaces
		userInput = rawUserInput.replace(' ', '')
		
		# strip user input of punctuation
		userInput = rawUserInput.translate(None, string.punctuation)
		
		# if T9 failed to correctly predict the word, none of T9's predictions are
		# inserted or updated in the dictionary or trie.
		predictionSuccessful = False
		
		# a list of indices of which letters in wordTypedSoFarLowercase are uppercase.
		# e.g. iPod -> [1]
		# e.g. UMich -> [0, 1]
		# This will be used to print suggested words with appropriately capitalized
		# letters.
		uppers = []
		
		# simulating the reading in of one character at a time.
		for c in userInput:
			
			# will hold the list of predicted words.
			suggestions = []
			
			# simulating the user having typed in another letter.
			wordTypedSoFarLowercase += c
			wordTypedSoFarOriginalCase += c
			
			# update the uppers list to keep track of where the uppercased letters are.
			if c in string.ascii_uppercase:
				uppers.append(len(wordTypedSoFarLowercase) - 1)
			
			# Set to all lowercase letters.
			wordTypedSoFarLowercase = wordTypedSoFarLowercase.lower()
			
			# the sequence of digits that the user would have actually typed
			keySeq = getKeySequence(wordTypedSoFarLowercase)
			
			print "Key sequence:", keySeq
			print "Suggestion for string:", wordTypedSoFarOriginalCase
			
			# Get suggestions for the current keys pressed and present to user
			suggestions = suggester(trie, cache, numResults, numCacheResults, keySeq, suggestionDepth, uppers)
			print suggestions
			
			# Assuming that the user stops texting when the desired word is predicted,
			# we move on to the next word.
			for s in suggestions:
				if s == rawUserInput:
					print "Word successfully predicted after", len(wordTypedSoFarLowercase), "chars typed."
					predictionSuccessful = True
			if predictionSuccessful:
				break
				
		# If, even after the whole word's key sequence is typed, T9 failed to predict
		# the desired word, then enter the new word into the trie, the cache, and the
		# dictioanry file.
		# Currently, we are not simulating how the user would specify what the new
		# word is.
		if not predictionSuccessful:
			print "Failed to predict word."
		
		# Sometimes, T9 fails to come up with any predictions before the last key is
		# typed.
		wordTypedSoFarLowercase = userInput.lower()
		keySeq = getKeySequence(wordTypedSoFarLowercase)
		if wordTypedSoFarLowercase != '':
			newFreq = trie.updateFrequency(wordTypedSoFarLowercase, keySeq)
			cache.update(wordTypedSoFarLowercase, newFreq, keySeq)
			
		print "--------------------------------------------------------------------------------"
		
		# Get next word.
		rawUserInput = raw_input("> ")
		wordTypedSoFarLowercase = ""
		wordTypedSoFarOriginalCase = ""
		
	print "Exiting..."
	# Restore the dictionary file to its original content.
	if rawUserInput == "reset()":
		trie.resetDictionary(filenameOriginal)
		
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
	
	# the number of levels in the Trie beyond the length of the
	# current word typed that will be probed for suggestions.
	# e.g. Current word typed is "ok" and suggestionDepth is 2, then 'okay' will
	# be among the suggestions. However, if suggestionDepth were 1, 'okay' would
	# be too long to be included in the suggestions.
	suggestionDepth = 10
	
	# the number of suggestions printed (counting numCacheResults).
	numResults = 8
	
	# the maximum number of words that the cache holds.
	cacheSize = 20
	
	# the number of suggestions from the cache that are printed.
	numCacheResults = 5
	
	# dictionary filename. the Trie is built from this.
	filename = "freqDict.txt"
	
	# filename of the original dictionary. for resetting the dictionary.
	filenameOriginal = "freqDictOriginal.txt"
	
	# Load the trie with the dictionary.
	T = Trie(filename)
	T.loadTrie(filename)
	
	# Interactive 'texting'
	texter(filename, filenameOriginal, T, suggestionDepth, cacheSize, numResults, numCacheResults)
	print ('|')
		
if __name__ == '__main__':
	main()