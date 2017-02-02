from string import ascii_lowercase
from re import *

class TrieNode:
	def __init__(self, parent):
		# Init dict of alphabet. Each letter maps to null
		self.children = dict.fromkeys(ascii_lowercase, None)
		self.alphabetSize = 26
		self.leaf = False
		self.parent = parent
	def isLeaf(self):
		return self.leaf
	def getBranch(self, c):
		return self.children[c]
	def hasChildren(self, c):
		return self.children[c] != None
	def putNode(self, c, trieNode):
		self.children[c] = trieNode
	def setAsLeaf(self):
		self.leaf = True
	
class Trie:
	def __init__(self):
		self.root = TrieNode(None)
	def insert(self, word):
		node = self.root
		for c in word:
			if not node.hasChildren(c):
				node.putNode(c, TrieNode(node))
			node = node.getBranch(c)
		node.setAsLeaf()
	def getPrefixLeaf(self, word):
		node = self.root
		for c in word:
			if node.hasChildren(c):
				node = node.getBranch(c)
			else:
				return None
		return node
	def wordExists(self, word):
		node = self.getPrefixLeaf(word)
		return node != None and node.isLeaf()
	def prefixExists(self, prefix):
		node = self.getPrefixLeaf(prefix)
		return node != None
	def getPrefixNode(self, prefix):
		node = self.getPrefixLeaf(prefix)
		if node != None:
			return node
		else:
			return None
		
def loadTrie(T, dictFileName):
	dictFile = open(dictFileName, 'r')
	for i, line in enumerate(dictFile):
		skip = False
		word = line.rstrip('\n')
		for c in word:
			# For now, cannot handle special chars
			if not (c in ascii_lowercase):
				skip = True
				break
		if not skip:
			T.insert(word)
	dictFile.close()
	return T
		
def main():
	T = Trie()
	
	print "--------------------TRIE-----------------"
	print "i <word>: insert word into Trie"
	print "w <word>: True if word in Trie, Else False"
	print "p <prefix>: True if a word in Trie contains <prefix>, Else False"
	print "q: quit"
	cmdline = raw_input("> ")
	while cmdline != "q":
		cmdargs = split('\s+', cmdline)
		if cmdargs[0] == 'i':
			T.insert(cmdargs[1])
		elif cmdargs[0] == 'w':
			print T.wordExists(cmdargs[1])
		elif cmdargs[0] == 'p':
			print T.prefixExists(cmdargs[1])
		else:
			pass
		cmdline = raw_input("> ")
	
	
if __name__ == '__main__':
	main()