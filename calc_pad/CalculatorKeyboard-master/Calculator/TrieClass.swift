//
//  TrieClass.swift
//  9key
//
//  Created by Alex Hsieh on 2/7/17.
//  Copyright © 2017 FAKS. All rights reserved.
//

import Foundation

public class TrieNode {
    //var key: String                 // the current letter
    var children: [String:TrieNode] // maps from number |-> TrieNode
    var words: [String:Int]        // maps from word choice |-> frequency
    var leaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    // initializes a new trie node
    init() {
        self.children = [:]
        self.words = [:]
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
    
    class DeeperSuggestion {
        var deeperSuggestions: Array<Array<String>> = [[String]]()
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
                        self.insert(word, Int(frequency)!)
                    }
                }
            }
        }
    }
    
    func insert(_ word : String, _ frequency : Int) {
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
            for (word, _) in prefixNode!.words {
                suggestions.append(word)
            }
            
            if suggestionDepth > 1 {
                var deeperSuggestions = DeeperSuggestion()
                deeperSuggestions = self.getDeeperSuggestions(prefixNode!, keySeq.characters.count + suggestionDepth)
                
                for depth in deeperSuggestions.deeperSuggestions {
                    for word in depth {
                        suggestions.append(word)
                    }
                }
            }
        }
        
        return suggestions
    }
    
    func getDeeperSuggestions(_ root : TrieNode, _ maxDepth : Int) -> DeeperSuggestion {
        var deeperSuggestions = DeeperSuggestion()
        // TODO: Implement me
        return deeperSuggestions
    }
    
    func traverse(_ root : TrieNode, _ depth : Int, _ maxDepth : Int, _ deepSuggestions : DeeperSuggestion) {
        if (depth < maxDepth && depth > 0) {
            for (w, _) in root.words {
                deepSuggestions.deeperSuggestions[depth-1].append(w)
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
                for (treeWord, _) in node!.words {
                    if treeWord == word {
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
            for (word, weight) in prefixNode!.words {
                if word == chosenWord {
                    newWeight = weight + 1
                    prefixNode!.words.updateValue(newWeight, forKey: word)
                    updateWeightInFile(chosenWord: chosenWord)
                    break
                }
            }
        }
        else {
            newWeight = 1
            insert(chosenWord, newWeight)
            insertWordInFile(chosenWord: chosenWord)
            
        }
        return newWeight
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
        
    }
}
