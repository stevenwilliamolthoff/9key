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
    var key: String!                // the current letter
    var children: [String:TrieNode] // maps from number |-> TrieNode
    var isLeaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    init() {
        self.children = [:]
        self.isLeaf = false
        self.level = 0
    }
    
    class func isLeaf() {
        return self.isLeaf;
    }
    
    class func getBranch(keyword: String) {
        return self.children[keyword];
    }
    
    class func hasChild(keyword: String) -> Bool {
        return self.children[keyword] != nil
    }
    
    class func putNode(keyword: String, tn : TrieNode) {
        self.children[keyword] = tn;
    }
    
    class func setAsLeaf() {
        self.isLeaf = true;
    }
}
