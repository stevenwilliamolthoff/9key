//
//  TrieClass.swift
//  9key
//
//  Created by Alex Hsieh on 2/7/17.
//  Copyright © 2017 FAKS. All rights reserved.
//

import Foundation

public class TrieNode {
    var key: String                 // the current letter
    var children: [String:TrieNode] // maps from number |-> TrieNode
    var words: [String:Uint]        // maps from word choice |-> frequency
    var isLeaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    // initializes a new trie node
    init() {
        self.children = [:]
        self.words = [:]
        self.isLeaf = false
        self.level = 0
    }
    
    // checks if node is a leaf (end of word)
    func isLeaf() {
        return self.isLeaf
    }
    
    // gets the next node based on key
    func getBranch(keyword: String) {
        return self.children[keyword]
    }
    
    // returns true if children is non-empty; false otherwise
    func hasChild(keyword: String) -> Bool {
        return self.children[keyword] != nil
    }
    
    // inserts new node into list of children
    func putNode(keyword: String, tn : TrieNode) {
        self.children[keyword] = tn
    }
    
    // makes node a leaf
    func setAsLeaf() {
        self.isLeaf = true
    }
}

public class Trie {
    // member variables for trie class
    var root: TrieNode
    var filename : String
    var dictionarySize : Int
    
    // initializes the data structure
    init(filename : String) {
        self.root = TrieNode()
        self.filename = filename
        self.dictionarySize = 0
    }
    
    func loadTrie(dictFileName : String) {
        // TODO: need to find way to effectively store trie and load it
        //       no swift interfacing for file i/o, consider serialization
        //       or Bundles i/o
    }
    
    func insert(word : String, frequency : Int) {
        // TODO: how to get values from data structure in separate file??
    }
    
    func getPrefixLeaf(keySeq : String) -> (TrieNode, Bool) {
        var node: TrieNode = self.root
        var prefixExists: Bool = true
        
        for key in keySeq.characters.indices {
            if node.hasChild(key) {
                node = node.getBranch(key)
            } else {
                if key == keySeq.characters.count - 1 {
                    prefixExists = true
                } else {
                    prefixExists = false
                    node = nil
                    return (node, prefixExists)
                }
            }
        }
        
        return (node, prefixExists)
    }
    
    func getPrefixNode(keySeq : String) -> TrieNode {
        let (node, prefixExists) = self.getPrefixLeaf(keySeq)
        
        if prefixExists {
            return node
        } else {
            return nil
        }
    }
    
    func getSuggestions(keySeq : String, suggestionDepth : Int) -> Array<String> {
        var suggestions = [String]()
        var prefixNode = self.getPrefixNode(keySeq)
        
        if prefixNode != nil {
            for (word, frequency) in prefixNode.words {
                suggestions.append(word)
            }
            
            if suggestionDepth > 1 {
                var deeperSuggestions = self.getDeeperSuggestions(prefixNode, keySeq.characters.count + suggestionDepth)
                
                for depth in deeperSuggestions {
                    for (word, frequency) in depth {
                        suggestions.append(word)
                    }
                }
            }
        }
        
        return suggestions
    }
    
    func getDeeperSuggestions(root : TrieNode, maxDepth : Int) -> Array<Array<String>> {
        // TODO: Implement me
    }
    
    func traverse(root : TrieNode, depth : Int, maxDepth : Int, deepSuggestions : Array<Array<String>>) -> Array<Array<String>> {
        if (depth < maxDepth && depth > 0) {
            if root.words != nil {
                deepSuggestions[depth-1].append(contentsOf: root.words)
            }
        }
        
        if depth == maxDepth {
            return deepSuggestions
        }
        
        if root.children != nil {
            return deepSuggestions
        }
        
        for key in root.children {
            self.traverse(root.children[key], depth+1, maxDepth, deepSuggestions)
        }
    }
    
    func wordExists(word : String, keySeq : String) -> Bool {
        let (node, prefixExists) = self.getPrefixLeaf(keySeq)
        
        if node != nil {
            if node.isLeaf() {
                for (treeWord, frequency) in node.words {
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
}
