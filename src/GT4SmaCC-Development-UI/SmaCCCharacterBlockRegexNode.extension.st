Extension { #name : #SmaCCCharacterBlockRegexNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCCharacterBlockRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: block
]
