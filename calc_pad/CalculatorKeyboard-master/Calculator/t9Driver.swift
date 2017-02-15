import Foundation

class T9 {
    // Filename of the dictionary that will be updated over time
    let dictionaryFilename: String
    
    // Filename of the original dictionary. For resetting the altered dictionary
    // to its original content. For testing purposes.
    let resetFilename: String
    
    // The number of levels deeper to probe in the Trie. The larger the number,
    // the longer the words that will be suggested.
    let suggestionDepth: UInt
    
    // The total number of suggestions to be returned from T9.
    let numResults: UInt
    
    // The prefix tree structure
    var trie: Trie
    init(dictionaryFilename: String,
         resetFilename: String,
         suggestionDepth: UInt,
         numResults: UInt) {
        self.dictionaryFilename = dictionaryFilename
        self.trie = Trie(filename: dictionaryFilename)
    }
}
