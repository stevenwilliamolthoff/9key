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
    
    class func findWord(keyword: String) -> Array<String>! {
        guard keyword.characters.count > 0 else {
            return nil
        }
        
        var current: TrieNode = root
        var wordList: Array<String> = Array<String>()
        
        while (keyword.characters.count != current.level) {
            var childToUse: TrieNode!
            let searchKey: String = keyword.substringToIndex(current.level + 1)
            
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
