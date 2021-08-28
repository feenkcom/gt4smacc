Extension { #name : 'SmaCCCharacterRegexNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCCharacterRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: char
]
