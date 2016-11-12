#-*- coding: utf-8 -*-

pat='パトカー'
tax='タクシー'
patTax=''
for x in xrange(0,len(pat),3):
	patTax+=pat[x:x+3]+tax[x:x+3]
print(patTax)
