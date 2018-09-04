Extension { #name : #SmaCCCharacterRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCCharacterRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: char
]
