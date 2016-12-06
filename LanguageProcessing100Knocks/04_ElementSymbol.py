def judge(x):
	return x==1 or x==5 or x==6 or x==7 or x==8 or x==9 or x==15 or x==16 or x==19 

sentence='Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King an.'
word=sentence.split(' ')
for x in xrange(len(word)):
	if judge(x):
		print(x)
		