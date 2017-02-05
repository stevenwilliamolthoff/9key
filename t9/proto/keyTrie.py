import re
import string
import os
import shutil
from keys import *
from operator import itemgetter

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
		self.dictionarySize = 0
		
	def loadTrie(self, dictFileName):
		dictFile = open(dictFileName, 'r')
		for i, line in enumerate(dictFile):
			self.dictionarySize += 1
			skip = False
			pair = re.split('\s+', line.rstrip('\n'))
			for c in pair[1]:
				# For now, cannot handle special chars
				if not (c in string.ascii_lowercase):
					skip = True
					break
			if not skip:
				self.__insert__(pair[1], int(pair[0]))
		dictFile.close()
		return self.dictionarySize

	def __insert__(self, word, frequency):
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
		
	def __getSuggestions__(self, keySequence, suggestionDepth):
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
		newFreq = -1
		prefix = self.getPrefixLeaf(keySeq)
		if self.wordExists(chosenWord, keySeq):
			for i in prefix[0].words:
				if i[0] == chosenWord:
					i[1] += 1
					newFreq = i[1]
					self.updateDictionaryFrequency(chosenWord)
					break
		else:
			newFreq = 1
			self.__insert__(chosenWord, newFreq)
			self.insertWordInDictionary(chosenWord)
		return newFreq
			
	def insertWordInDictionary(self, chosenWord):
		newFileName = "new" + self.filename
		with open(self.filename, 'a') as f:
			f.write('1\t' + chosenWord + '\n')
			
	def updateDictionaryFrequency(self, chosenWord):
		newFileName = "new" + self.filename
		with open(self.filename, 'r') as input_file, open(newFileName, 'w') as output_file:
			for i, line in enumerate(input_file):
				pair = re.split('\s+', line.rstrip('\n'))
				if pair[1] == chosenWord:
					output_file.write(str(int(pair[0]) + 1) + '\t' + chosenWord)
					if i == self.dictionarySize - 1:
						output_file.write('\n')
				else:
					output_file.write(line)
		os.rename(newFileName, self.filename)
	
	def resetDictionary(self, sourceName):
		shutil.copy(sourceName, self.filename)