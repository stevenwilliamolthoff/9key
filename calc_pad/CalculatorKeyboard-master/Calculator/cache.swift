//import TrieClass

// http://stackoverflow.com/questions/24090016/sort-dictionary-by-values-in-swift#24090641
extension Dictionary {
	func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
		return Array(self.keys).sort(isOrderedBefore)
	}

	// Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
	func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
		return sortedKeys {
			isOrderedBefore(self[$0]!, self[$1]!)
		}
	}

	// Faster because of no lookups, may take more memory because of duplicating contents
	func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
		return Array(self)
			.sort() {
				let (_, lv) = $0
				let (_, rv) = $1
				return isOrderedBefore(lv, rv)
			}
			.map {
				let (k, _) = $0
				return k
			}
	}
}

public class CacheNode: TrieNode {
	var parentNode: CacheNode
	init(parentNode: CacheNode) {
		self.parentNode = parentNode
	}
}

public class CacheTrie: Trie {
	var root = CacheNode(nil)
	func insert(word: String, frequency: UInt) {
		var parentNode = CacheNode(nil)
		var node = self.root
		var key = 0
		for c in word.characters {
			key = keys[c]
			if !node.hasChildren(key) {
				node.putNode(key, CacheNode(parentNode))
			}
			parentNode = node
			node = node.getBranch(key)
		}
		node.setAsLeaf()
		node.words[word] = frequency
		// FIXME: Is the comparison operator the right way?
		node.words.keysSortedByValue(>)
	}
	func getSuggestions(keySequence: [Int], suggestionDepth: Int) -> [String] {
		return self.__getSuggestions__(keySequence, suggestionDepth)
	}
}

public class Cache {
	let sizeLimit: Int
	var cacheList: [String]
	var cachTrie = CacheTrie()
	init(sizeLimit: Int) {
		self.sizeLimit = sizeLimit
		self.cacheList = []
	}
	func getSuggestions(keySequence: [Int], suggestionDepth: Int) -> [String] {
		return self.cacheTrie.getSuggestions(keySequence, suggestionDepth)
	}
	func update(chosenWord: String, frequency: UInt, keySequence: [Int]) {
		oldIndex = -1
		for (i, word) in cacheList.enumerated() {
			if word == chosenWord {
				oldIndex = i
				break
			}
		}
		// if chosenWord is in the cache, move it to front,
		// and update frequency in cacheTrie
		if oldIndex != -1 {
			self.cacheList.insert(0, self.cacheList.pop(oldIndex))
			self.updateFrequency(chosenWord, keySequence)
		}
		else {
			self.insert(chosenWord, frequency)
		}
	}
	func updateFrequency(chosenWord: String, keySequence: [Int]) {
		prefix = self.getPrefixLeaf(keySeq)
		if self.wordExists(chosenWord, keySeq) {
			prefixNode = prefix.0
			// prefixNode.words is a dict from words to frequencies
			for w in prefixNode.words {
				if w == chosenWord {
					prefixNode.words[w] += 1
					break
				}
			}
		}
	}
	// Only call from update() so that we've already checked
 	// to see if chosenWord is in the cache
	func insert(word: String, frequency: UInt) {
		// if @ capacity
		if self.cacheList.count() == self.sizeLimit {
			self.pruneOldest()
		}
		// put most recent word at beginning
		if self.cacheList != nil {
			self.cacheList[0] = word
		}
		self.cacheTrie.insert(word, frequency)
	}
	func pruneOldest() {
		self.pruneWord(cacheList[cacheList.count() - 1])
	}
	func pruneWord(wordToPrune: String) {
		nodeToPrude = CacheTrie.getPrefixNode(wordToPrune)
		// If wordToPrune is a prefix with other children, just remove this one word from the word list of nodeToPrune
		if nodeToPrune.children != nil {
			nodeToPrune.words.removeValueForKey(wordToPrune)
			return
		}
		else {
			self.pruneNode(nodeToPrune)
		}
	}
	func pruneNode(nodeToPrune: CacheNode) {
		// parent has no keys in children other than the target's key
		if nodeToPrune.parentNode.children.count() == 1 {
			self.pruneNode(nodeToPrune.parentNode)
		}
		else {
			nodeToPrune = nil
		}
	}
	func clear() {
		self = Cache(self.sizeLimit)
	}
}
