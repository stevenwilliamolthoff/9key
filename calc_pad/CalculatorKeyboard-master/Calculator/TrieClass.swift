//
//  TrieClass.swift
//  9key
//
//  Created by Alex Hsieh on 2/7/17.
//  Copyright © 2017 FAKS. All rights reserved.
//

import Foundation

public class WordWeight {
    let word: String
    var weight: Int
    init(word: String, weight: Int) {
        self.word = word
        self.weight = weight
    }
}

public class TrieNode {
    
    //var key: String                 // the current letter
    var children: [String:TrieNode] // maps from number |-> TrieNode
    var wordWeights: [WordWeight]        // maps from word choice |-> frequency
    var leaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    // initializes a new trie node
    init() {
        self.children = [:]
        self.wordWeights = [WordWeight]()
        self.leaf = false
        self.level = 0
    }
    
    // checks if node is a leaf (end of word)
    func isLeaf() -> Bool {
        return self.leaf
    }
    
    // gets the next node based on key
    func getBranch(_ keyword: String) -> TrieNode {
        return self.children[keyword]!
    }
    
    // returns true if children is non-empty; false otherwise
    func hasChild(_ keyword: String) -> Bool {
        return self.children[keyword] != nil
    }
    
    // inserts new node into list of children
    func putNode(_ keyword: String, _ tn : TrieNode) {
        self.children[keyword] = tn
    }
    
    // makes node a leaf
    func setAsLeaf() {
        self.leaf = true
    }
}

public class Trie {
    // member variables for trie class
    var root: TrieNode
    var filename : String
    var dictionarySize : Int
    var filemgr : FileManager
    
    // The reverse mapping from letters to key numbers
    let lettersToDigits = ["a" : 2, "b" : 2, "c" : 2,
                           "d" : 3, "e" : 3, "f" : 3,
                           "g" : 4, "h" : 4, "i" : 4,
                           "j" : 5, "k" : 5, "l" : 5,
                           "m" : 6, "n" : 6, "o" : 6,
                           "p" : 7, "q" : 7, "r" : 7, "s" : 7,
                           "t" : 8, "u" : 8, "v" : 8,
                           "w" : 9, "x" : 9, "y" : 9, "z" : 9]
    
    class DeeperSuggestion {
        var deeperSuggestions: Array<Array<WordWeight>> = [[WordWeight]]()
    }
    
    // initializes the data structure
    init(filename : String) {
        self.root = TrieNode()
        self.filename = filename
        self.dictionarySize = 0
        self.filemgr = FileManager.default
    }
    
    func loadTrie(_ dictFileName : String) {
        let letters = CharacterSet.letters
        
        // get path to dictionary for inserting new word
        let filepath1 = filemgr.currentDirectoryPath + "/dict.txt"
        
        // check if the file is readable
        if filemgr.isReadableFile(atPath: filepath1) {
            // get the file to read from
            let file: FileHandle? = FileHandle(forReadingAtPath: filepath1)
            
            // if file exists and is readable then read from it
            if file == nil {
                print("File open failed")
            } else {
                let url = URL(fileURLWithPath: filepath1) // convert string pathname to url type
                let contents = try! String(contentsOf: url) // fetch contents from the file
                let lines = contents.components(separatedBy: .newlines) // split contents by newline
                
                for line in lines {
                    // increment dictionary size
                    self.dictionarySize += 1
                    var skip : Bool = false;
                    
                    // fetch frequency and word from string array
                    var comp = line.components(separatedBy: "\t")
                    var frequency = comp[0]
                    var word = comp[1]
                    //let (frequency, word) = line.components(separatedBy: "\t")
                    
                    // string check for acceptable characters
                    for ch in word.unicodeScalars {
                        var str = String(ch)
                        
                        // must be lowercase and alphabetic character for now
                        if !(letters.contains(ch) && str.lowercased() == str) {
                            skip = true;
                            break;
                        }
                    }
                    
                    // add into trie
                    if !skip {
                        self.insert(word: word, weight: Int(frequency)!)
                    }
                }
            }
        }
    }
    
    func insert(word : String, weight : Int) {
        var node = self.root
        var key = 0
        for c in word.characters {
            key = lettersToDigits[String(c)]!
            if !node.hasChild(String(key)) {
                node.putNode(String(key), TrieNode())
            }
            node = node.getBranch(String(key))
        }
        node.setAsLeaf()
        node.wordWeights.append(WordWeight(word: word, weight: weight))
        
        // Sorts wordWeights by weights, biggest to smallest weight
        node.wordWeights = node.wordWeights.sorted(by: {$0.weight > $1.weight})
        // TODO: how to get values from data structure in separate file??
    }
    
    func getPrefixLeaf(_ keySeq : String) -> (TrieNode?, Bool) {
        var node: TrieNode? = self.root
        var prefixExists: Bool = true
        
        for key in keySeq.characters {
            if node!.hasChild(String(key)) {
                node = node!.getBranch(String(key))
            } else {
                if Int(String(key)) == keySeq.characters.count - 1 {
                    prefixExists = true
                } else {
                    prefixExists = false
                    node = nil
                    return (node!, prefixExists)
                }
            }
        }
        
        return (node!, prefixExists)
    }
    
    func getPrefixNode(_ keySeq : String) -> TrieNode? {
        let (node, prefixExists) = self.getPrefixLeaf(keySeq)
        
        if prefixExists {
            return node
        } else {
            return nil
        }
    }
    
    func getSuggestions(_ keySeq : String, _ suggestionDepth : Int) -> Array<String> {
        var suggestions = [String]()
        let prefixNode: TrieNode? = self.getPrefixNode(keySeq)
        
        if prefixNode != nil {
            for wordWeight in prefixNode!.wordWeights {
                suggestions.append(wordWeight.word)
            }
            
            if suggestionDepth > 1 {
                var deeperSuggestions = DeeperSuggestion()
                // deeperSuggestions is a classs, so it is passed by reference
                // After the call to getDeeperSuggestions, deeperSuggestions
                // will be a list of lists of words, each list being full of
                // words of one character longer in length
                self.getDeeperSuggestions(root: prefixNode!,
                                          maxDepth: keySeq.characters.count + suggestionDepth,
                                          deeperSuggestions: deeperSuggestions)
                
                for level in deeperSuggestions.deeperSuggestions {
                    for wordWeight in level {
                        suggestions.append(wordWeight.word)
                    }
                }
            }
        }
        
        return suggestions
    }
    
    func getDeeperSuggestions(root : TrieNode, maxDepth : Int, deeperSuggestions: DeeperSuggestion) {
        self.traverse(root, 0, maxDepth, deeperSuggestions)
        for (level, suggestions) in deeperSuggestions.deeperSuggestions.enumerated() {
            if suggestions.count > 0 {
                deeperSuggestions.deeperSuggestions[level] = suggestions.sorted(by: {$0.weight > $1.weight})
            }
        }
    }
    
    func traverse(_ root : TrieNode, _ depth : Int, _ maxDepth : Int, _ deepSuggestions : DeeperSuggestion) {
        if (depth < maxDepth && depth > 0) {
            for wordWeight in root.wordWeights {
                deepSuggestions.deeperSuggestions[depth-1].append(wordWeight)
            }
        }
        
        if depth == maxDepth || root.children.count == 0 {
            return
        }
        
        for (key, _) in root.children {
            self.traverse(root.children[key]!, depth+1, maxDepth, deepSuggestions)
        }
    }
    
    func wordExists(_ word : String, _ keySeq : String) -> Bool {
        let (node, _) = self.getPrefixLeaf(keySeq)
        
        if node != nil {
            if node!.isLeaf() {
                for wordWeight in node!.wordWeights {
                    if wordWeight.word == word {
                        return true
                    }
                }
                
                return false
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func updateWeight(chosenWord: String, keySeq: String) -> Int {
        var newWeight = -1
        let prefixNode = getPrefixLeaf(keySeq).0
        if wordExists(chosenWord, keySeq) {
            for wordWeight in prefixNode!.wordWeights {
                if wordWeight.word == chosenWord {
                    newWeight = wordWeight.weight + 1
                    wordWeight.weight = newWeight
                    updateWeightInFile(chosenWord: chosenWord)
                    break
                }
            }
        }
        else {
            newWeight = 1
            insert(word: chosenWord, weight: newWeight)
            insertWordInFile(chosenWord: chosenWord)
            
        }
        return newWeight
    }
    
    // To do: assumption that word is already in Trie,
    // must find a way to update currentSuggestions in T9.
    // updateWeight assumes the word exists in the Trie
    // insert assumes it does not
    //    func updateWeight(chosenWord: String) {
    //        let keySeq = wordToKeys(word: chosenWord)
    //
    //    }
    
    func wordToKeys(word: String) -> [Int] {
        var keySequence: [Int]
        for char in word.characters {
            keySequence.append(lettersToDigits[String(char)]!)
        }
    }
    
    func insertWordInFile(chosenWord: String) {
        // get path to dictionary for inserting new word
        let filepath1 = filemgr.currentDirectoryPath + "/dict.txt"
        
        // check if the file is writable
        if filemgr.isWritableFile(atPath: filepath1) {
            let file: FileHandle? = FileHandle(forUpdatingAtPath: filepath1)
            
            if file == nil {
                print("file could not be opened")
            } else {
                // data will just be the word and frequency of 1 since it is a new word
                let data = ("1" + "\t" + chosenWord as String).data(using: String.Encoding.utf8)
                
                // since this is a new word, we want to find the EOF and append the word/freq pair there
                file?.seekToEndOfFile()
                
                // write the data to the file and close file after operation is complete
                file?.write(data!)
                file?.closeFile()
            }
        }
    }
    
    func updateWeightInFile(chosenWord: String) {
        let urlOfDict = URL(fileURLWithPath: self.filename)
        do {
            let dictStr = try String(contentsOf: urlOfDict, encoding: String.Encoding.utf8)
            let separators = CharacterSet(charactersIn: "\t\n")
            var dictStrArr = dictStr.components(separatedBy: separators)
            var updatedDictStr = ""
            var wordFound = false
            for i in stride(from: 1, to:dictStrArr.count, by: 2) {
                if !wordFound {
                    if dictStrArr[i] == chosenWord {
                        // Add one to weight
                        dictStrArr[i-1] = String(Int(dictStrArr[i-1])! + 1)
                        wordFound = true
                    }
                }
                updatedDictStr += dictStrArr[i-1] + "\t" + dictStrArr[i] + "\n"
            }
            try updatedDictStr.write(to: urlOfDict, atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("fail")
        }
    }
}
