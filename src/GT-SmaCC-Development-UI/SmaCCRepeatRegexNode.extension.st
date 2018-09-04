Extension { #name : #SmaCCRepeatRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCRepeatRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: count
]
