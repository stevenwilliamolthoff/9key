//
//  TrieClass.swift
//  9key
//
//  Created by User on 2/7/17.
//  Copyright © 2017 FAKS. All rights reserved.
//

import Foundation

public class TrieNode {
    var key: String!                // the current letter
    var children: Array<TrieNode>   // search tree of possible subsequent letters
    var isLeaf: Bool                // is this node the leaf node?
    var level: Int                  // depth of this node
    
    init() {
        self.children = Array<TrieNode>()
        self.isLeaf = false
        self.level = 0
    }
    
    class func addWord(keyword: String) {
        guard keyword.length > 0 else {
            return
        }
        
        var current: TrieNode = root
        
        while (keyword.length != current.level) {
            var childToUse: TrieNode!
            let searchKey: String = keyword.substringToIndex(current.level + 1)
            
            //iterate through the node children
            for child in current.children {
                if (child.key == searchKey) {
                    childToUse = child
                    break
                }
            }
            //create a new node
            if (childToUse == nil) {
                childToUse = TrieNode()
                childToUse.key = searchKey
                childToUse.level = current.level + 1
                current.children.append(childToUse)
            }
            
            current = childToUse
        } //end while 
        
        //final end of word check 
        if (keyword.length == current.level) {
            current.isFinal = true
            print("end of word reached!")
            return
        }
    }
    
    class func findWord(keyword: String) -> Array<String>! {
        guard keyword.characters.count > 0 else {
            return nil
        }
        
        var current: TrieNode = root
        var wordList: Array<String> = Array<String>()
        
        while (keyword.characters.count != current.level) {
            var childToUse: TrieNode!
            
            let start = keyword.index(keyword.startIndex, offsetBy: current.level+1)
            let end = keyword.index(keyword.startIndex, offsetBy: current.level+2)
            let range = start..<end
            let searchKey: String = keyword.substring(with: range)
            
            //iterate through any children
            for child in current.children {
                if (child.key == searchKey) {
                    childToUse = child
                    current = childToUse
                    break
                }
            }
            
            if childToUse == nil {
                return nil
            }
        } //end while
        
        //retrieve the keyword and any decendants
        if ((current.key == keyword) && (current.isLeaf)) {
            wordList.append(current.key)
        }
        
        //include only children that are words
        for child in current.children {
            if (child.isLeaf == true) {
                wordList.append(child.key)
            }
        }
        
        return wordList
    }
}
