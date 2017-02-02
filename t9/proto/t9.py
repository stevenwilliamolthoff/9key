from __future__ import division
from math import log
import string
from operator import itemgetter
import re
import os
import shutil
 
# Sources:
# http://www.mitchrobb.com/t9-in-javascript-with-a-prefix-tree/
# https://leetcode.com/articles/implement-trie-prefix-tree/

keys = {
	'a': 2, 'b': 2, 'c': 2,
	'd': 3, 'e': 3, 'f': 3,
	'g': 4, 'h': 4, 'i': 4,
	'j': 5, 'k': 5, 'l': 5,
	'm': 6, 'n': 6, 'o': 6,
	'p': 7, 'q': 7, 'r': 7, 's': 7,
	't': 8, 'u': 8, 'v': 8,
	'w': 9, 'x': 9, 'y': 9, 'z': 9
};

class TrieNode:
	def __init__(self):
		self.children = {} # : number |-> TrieNode
		self.words = [] # [[word, frequency], [word, frequency], ...]
		self.leaf = False
	def isLeaf(self):
		return self.leaf
	def getBranch(self, key):
		return self.children[key]
	def hasChildren(self, key):
		return (key in self.children)
	def putNode(self, key, trieNode):
		self.children[key] = trieNode
	def setAsLeaf(self):
		self.leaf = True

class Trie:
	def __init__(self, filename):
		self.root = TrieNode()
		self.filename = filename

	def insert(self, word, frequency):
		# First, create the path for the word.
		node = self.root
		key = 0
		for c in word:
			key = keys[c]
			if not node.hasChildren(key):
				node.putNode(key, TrieNode())
			node = node.getBranch(key)
		node.setAsLeaf()
		# Secondly, insert the word into the last node's list
		node.words.append([word, frequency])
		node.words = sorted(node.words, key = itemgetter(1))
		
	def getSuggestions(self, keySequence, suggestionDepth):
		suggestions = []
		prefixNode = self.getPrefixNode(keySequence)
		# Prefix has been found and there are deeper word paths remaining
		if prefixNode != None:
			for pair in prefixNode.words:
				suggestions.append(pair[0])
			if suggestionDepth > 1:
				deeperSuggestions = self.getDeeperSuggestions(prefixNode, suggestionDepth)
				for depth in deeperSuggestions:
					for pair in depth:
						suggestions.append(pair[0])
		return suggestions
		
	def getDeeperSuggestions(self, root, maxDepth):
		# a list of maxDepth lists.
		# each inner list is filled with the suggestions from that depth
		deepSuggestions = [[] for x in xrange(maxDepth)]
		self.traverse(root, 0, maxDepth, deepSuggestions)
		for i in range(len(deepSuggestions)):
			if deepSuggestions[i]:
				deepSuggestions[i] = sorted(deepSuggestions[i], key = itemgetter(1))
		return deepSuggestions
		
	def traverse(self, root, depth, maxDepth, deepSuggestions):
		if (depth <= maxDepth and depth > 0):
			if root.words != None:
				deepSuggestions[depth-1].extend(root.words)
		if depth == maxDepth:
			return deepSuggestions
		if not root.children:
			return deepSuggestions
		for key in root.children:
			self.traverse(root.children[key], depth + 1, maxDepth, deepSuggestions)
		
	def getPrefixLeaf(self, keySeq):
		node = self.root
		prefixExists = True
		for k in keySeq:
			if node.hasChildren(k):
				node = node.getBranch(k)
			else:
				if k == len(keySeq) - 1:
					prefixExists = True
				else:
					prefixExists = False
					node = None
					return [node, prefixExists]
		return [node, prefixExists]
		
	def getPrefixNode(self, keySeq):
		prefix = self.getPrefixLeaf(keySeq)
		if prefix[1]:
			return prefix[0]
		else:
			return None
			
	def wordExists(self, word, keySeq):
		prefix = self.getPrefixLeaf(keySeq)
		if prefix[0]:
			if prefix[0].isLeaf():
				for pairs in prefix[0].words:
					if pairs[0] == word:
						return True
				return False
			else:
				return False
		else:
			return False
			
	def updateFrequency(self, chosenWord, keySeq):
		prefix = self.getPrefixLeaf(keySeq)
		if self.wordExists(chosenWord, keySeq):
			for i in prefix[0].words:
				if i[0] == chosenWord:
					i[1] += 1
					self.updateDictionaryFrequency(chosenWord)
					break
		else:
			self.insert(chosenWord, 1)
			self.insertWordInDictionary(chosenWord)
			
	def insertWordInDictionary(self, chosenWord):
		newFileName = "new" + self.filename
		with open(self.filename, 'a') as f:
			f.write('\n1\t' + chosenWord)
			
	def updateDictionaryFrequency(self, chosenWord):
		newFileName = "new" + self.filename
		with open(self.filename, 'r') as input_file, open(newFileName, 'w') as output_file:
			for line in input_file:
				pair = re.split('\s+', line.rstrip('\n'))
				if pair[1] == chosenWord:
					output_file.write(str(int(pair[0]) + 1) + '\t' + chosenWord + '\n')
				else:
					output_file.write(line)
		os.rename(newFileName, self.filename)
	
	def resetDictionary(self, sourceName):
		shutil.copy(sourceName, self.filename)
			
''' Experimenting with writing a dictionary with a different predictive measure
def probDict():
	with open("freqDict.txt", 'r') as input_file, open("out.txt", 'w') as output_file:
		for line in input_file:
			pair = re.split('\s+', line.rstrip('\n')) # 85714226
			output_file.write(str(log(int(pair[0])/1000, 1.1)) + '\t' + pair[1] + '\n')
'''
			
def loadTrie(T, dictFileName):
	dictFile = open(dictFileName, 'r')
	for i, line in enumerate(dictFile):
		skip = False
		pair = re.split('\s+', line.rstrip('\n'))
		for c in pair[1]:
			# For now, cannot handle special chars
			if not (c in string.ascii_lowercase):
				skip = True
				break
		if not skip:
			T.insert(pair[1], int(pair[0]))
	dictFile.close()
	return T
	
def getKeySequence(word):
	keySeq = []
	for c in word:
		keySeq.append(keys[c])
	return keySeq

def texter(T, suggestionDepth, numResults):
	cmdline = raw_input("> ")
	word = ""
	while cmdline != "reset()" and cmdline != "quit()":
		cmdline = cmdline.replace(' ', '')
		cmdline = cmdline.lower()
		cmdline = cmdline.translate(None, string.punctuation)
		for c in cmdline:
			word += c
			keySeq = getKeySequence(word)
			print "Key sequence:", keySeq
			print "Suggestion for string:", word
			print T.getSuggestions(keySeq, suggestionDepth)[:numResults]
		T.updateFrequency(word, keySeq)
		cmdline = raw_input("> ")
		word = ""
	print "Exiting..."
	if cmdline == "reset()":
		T.resetDictionary("freqDictOriginal.txt")
		
def main():
	print "----------T9 Prototype----------"
	print "Enter a word. A list of word predictions will be printed as each letter is read."
	print "Predictions are returned in an order - by shortest valid words, and then and by an estimated frequency of use."
	print "Currently, only lower-case ascii chars are supported. No capitals, no spaces or punctuation, no numbers, etc. Will be coming."
	print "Type 'reset() to quit without saving changes to dictionary."
	suggestionDepth = 10
	numResults = 3
	filename = "freqDict.txt"
	T = Trie(filename)
	loadTrie(T, filename)
	texter(T, suggestionDepth, numResults)
	print ('|')
		
if __name__ == '__main__':
	main()