class WeightedWord {
	let word: String
	let weight: Double
	// FIXME: datatype ^ subject to change
	init(word: String, weight: Double) {
		self.word = word
		self.weight = weight
	}
}

class TrieNode {
	var children: [Int : TrieNode]?
	var words: [WeightedWord]?
	var isALeaf: Bool
	init() {
		self.isALeaf = false
	}
}