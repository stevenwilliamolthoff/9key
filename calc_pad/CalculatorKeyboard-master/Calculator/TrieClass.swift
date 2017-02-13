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
    var words: [String:UInt]        // maps from word choice |-> frequency
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
    
    class DeeperSuggestion {
        var deeperSuggestions: Array<Array<String>> = [[String]]()
    }
    
    // initializes the data structure
    init(filename : String) {
        self.root = TrieNode()
        self.filename = filename
        self.dictionarySize = 0
    }
    
    func loadTrie(_ dictFileName : String) {
        // TODO: need to find way to effectively store trie and load it
        //       no swift interfacing for file i/o, consider serialization
        //       or Bundles i/o
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
        let (node, prefixExists) = self.getPrefixLeaf(keySeq)
        
        if node != nil {
            if node!.isLeaf() {
                for (treeWord, frequency) in node!.words {
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
    func updateFrequency() {
        
    }
}
