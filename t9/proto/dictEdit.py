import re

fin = open("freqDictOriginal.txt", 'r')
fout = open('freqDictOriginal2.txt', 'w')
word1 = ''
word2 = ''

for i in range(6312):
	lineList = re.split('\s+', fin.readline().rstrip('\n'))
	word2 = word1
	word1 = lineList[1]
	if word1 != word2:
		fout.write(lineList[0] + '\t' + lineList[1] + '\n')
		
fin.close()
fout.close()