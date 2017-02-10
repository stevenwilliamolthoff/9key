//
//  TrieClass.swift
//  9key
//
//  Created by Alex Hsieh on 2/7/17.
//  Copyright © 2017 FAKS. All rights reserved.
//

// Some code snippets were taken from Wayne Bishop's tutorial on how to create
// a Trie data structure in Swift and adapted to fit with Swift 3.0
// Link to blog tutorial can be found here: http://waynewbishop.com/swift/tries/

import Foundation

public class TrieNode {
    var key: String                 // the current letter
    var children: [String:TrieNode] // maps from number |-> TrieNode
    var isLeaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    // initializes a new trie node
    init() {
        self.children = [:]
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
    var root: TrieNode
    var filename : String
    var dictionarySize : Int
    
    init(filename : String) {
        self.root = TrieNode()
        self.filename = filename
        self.dictionarySize = 0
    }
    
    func loadTrie(dictFileName : String) {
        
    }
}
