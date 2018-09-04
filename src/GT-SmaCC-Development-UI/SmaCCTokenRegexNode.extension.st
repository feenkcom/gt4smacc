Extension { #name : #SmaCCTokenRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCTokenRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: name
]
