Extension { #name : #SmaCCCharacterBlockRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCCharacterBlockRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: block
]
