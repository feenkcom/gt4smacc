Extension { #name : #SmaCCRegexNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCRegexNode >> testTokensDo: aBlock [
	leftParens do: aBlock.
	rightParens do: aBlock
]
