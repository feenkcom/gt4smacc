Extension { #name : #SmaCCRepeatRegexNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCRepeatRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: count
]
