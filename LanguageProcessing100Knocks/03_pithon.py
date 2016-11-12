sentence='Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics'.replace(',','')
sentenceArray=sentence.split(" ")
wordLengthList=[]
for x in xrange(len(sentenceArray)):
	wordLengthList.append(len(sentenceArray[x]))

	
print(wordLengthList)