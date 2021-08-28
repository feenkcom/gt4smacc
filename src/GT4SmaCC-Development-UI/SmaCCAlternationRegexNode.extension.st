Extension { #name : 'SmaCCAlternationRegexNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCAlternationRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	barTokens do: aBlock
]
