import Foundation

// http://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}

class T9 {
    // Filename of the dictionary that will be updated over time
    let dictionaryFilename: String
    
    // Filename of the original dictionary. For resetting the altered dictionary
    // to its original content. For testing purposes.
    let resetFilename: String
    
    // The number of levels deeper to probe in the Trie. The larger the number,
    // the longer the words that will be suggested.
    let suggestionDepth: Int
    
    // The total number of suggestions to be returned from T9.
    let numResults: Int
    
    // The prefix tree structure
    var trie: Trie
    
    // The most recent returned list of suggestions
    var currentSuggestions: [String]
    
    // The reverse mapping from letters to key numbers
    let lettersToDigits = ["a" : 2, "b" : 2, "c" : 2,
                           "d" : 3, "e" : 3, "f" : 3,
                           "g" : 4, "h" : 4, "i" : 4,
                           "j" : 5, "k" : 5, "l" : 5,
                           "m" : 6, "n" : 6, "o" : 6,
                           "p" : 7, "q" : 7, "r" : 7, "s" : 7,
                           "t" : 8, "u" : 8, "v" : 8,
                           "w" : 9, "x" : 9, "y" : 9, "z" : 9]
    
    init(dictionaryFilename: String,
         resetFilename: String,
         suggestionDepth: Int,
         numResults: Int) {
        self.dictionaryFilename = dictionaryFilename
        self.trie = Trie(filename: dictionaryFilename)
        self.numResults = numResults
        self.suggestionDepth = suggestionDepth
        self.resetFilename = resetFilename
    }
    
    func getSuggestions(keySequence: String, shiftSequence: [Bool]) -> [String] {
        var suggestions = [String]()
        suggestions = trie.getSuggestions(keySequence, Int(suggestionDepth))
        var limitedSuggestions = [String]()
        for (i, word) in suggestions.enumerated() {
            if i >= numResults {
                break
            }
            limitedSuggestions.append(word)
        }
        for (i, word) in limitedSuggestions.enumerated() {
            var wordWithShifts: String
            for (j, shiftStatus) in shiftSequence.enumerated() {
                if shiftStatus {
                    wordWithShifts.append(word[j].uppercased())
                    limitedSuggestions[i] = wordWithShifts
                }
            }
        }
        currentSuggestions = limitedSuggestions
        return limitedSuggestions
    }
    
    func rememberChoice(chosenWord: String) {
        // If the chosen word was one of the suggestions, update its weight in
        // the Trie
        if currentSuggestions.contains(chosenWord) {
            let keySeq = wordToKeys(word: chosenWord)
            trie.updateWeight(chosenWord: chosenWord, keySeq: keySeq)
        }
        else {
            trie.insertWordInFile(chosenWord: chosenWord)
        }
        //return trie.updateWeight(chosenWord: selected, keySeq: "")
    }
    
    private func wordToKeys(word: String) -> [Int] {
        var keySequence: [Int]
        for char in word.characters {
            keySequence.append(lettersToDigits[String(char)]!)
        }
    }
}
