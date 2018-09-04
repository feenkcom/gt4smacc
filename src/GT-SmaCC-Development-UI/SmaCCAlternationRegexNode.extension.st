Extension { #name : #SmaCCAlternationRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAlternationRegexNode >> testIntervalsDo: aBlock [
	barTokens do: [ :each | aBlock value: each startPosition value: each stopPosition ]
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAlternationRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	barTokens do: aBlock
]
