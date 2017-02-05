from keyTrie import *

class CacheNode(TrieNode):
	def __init__(self, parentNode):
		TrieNode.__init__(self)
		self.parentNode = parentNode
	def setParent(self, parentNode):
		self = CacheNode(parentNode)
		
class CacheTrie(Trie):
	def __init__(self):
		Trie.__init__(self, "none")
		self.root = CacheNode(None)
	
	def insert(self, word, frequency):
		parentNode = None
		node = self.root
		key = 0
		for c in word:
			key = keys[c]
			if not node.hasChildren(key):
				node.putNode(key, CacheNode(parentNode))
			parentNode = node
			node = node.getBranch(key)
		node.setAsLeaf()
		node.words.append([word, frequency])
		node.words = sorted(node.words, key = itemgetter(1))
		
	def getSuggestions(self, keySequence, suggestionDepth):
		return self.__getSuggestions__(keySequence, suggestionDepth)
		
class Cache:
	def __init__(self, sizeLimit):
		self.sizeLimit = sizeLimit
		self.cacheList = []
		self.cacheTrie = CacheTrie()

	def getSuggestions(self, keySequence, suggestionDepth):
		return self.cacheTrie.getSuggesions(keySequence, suggestionDepth)

	def update(self, chosenWord, frequency, keySequence):
		oldIndex = -1
		for i, word in enumerate(self.cacheList):
			if word == chosenWord:
				oldIndex = i
				break
		# if chosenWord is in the cache, move it to front,
		# and update frequency in cacheTrie
		if oldIndex != -1:
			self.cacheList.insert(0, self.cacheList.pop(oldIndex))
			self.updateFrequency(chosenWord, keySequence)
		else:
			self.insert(chosenWord, frequency)
			
	def updateFrequency(self, chosenWord, keySequence):
		prefix = self.getPrefixLeaf(keySeq)
		if self.wordExists(chosenWord, keySeq):
			for i in prefix[0].words:
				if i[0] == chosenWord:
					i[1] += 1
					break

	# Only call from update() so that we've already checked
	# to see if chosenWord is in the cache
	def insert(self, word, frequency):
		# if @ capacity
		if len(self.cacheList) == self.sizeLimit:
			self.pruneOldest()
		# put most recent word at beginning
		if self.cacheList:
			self.cacheList[0] = word
		self.cacheTrie.insert(word, frequency)

	def pruneOldest(self):
		self.pruneWord(cacheList[len(cacheList) - 1])

	def pruneWord(self, wordToPrune):
		nodeToPrude = CacheTrie.getPrefixNode(wordToPrune)
		# If wordToPrune is a prefix with other children, just remove this one word from the word list of nodeToPrune
		if nodeToPrune.children:
			nodeToPrune.words.remove(wordToPrune)
			return
		else:
			self.pruneNode(nodeToPrune)

	def pruneNode(self, nodeToPrune):
		# parent has no keys in children other than the target's key
		if len(nodeToPrune.parentNode.children) == 1:
			self.pruneNode(nodeToPrune.parentNode)
		else:
			nodeToPrune = None

	def clear(self):
		self = Cache(self.sizeLimit)