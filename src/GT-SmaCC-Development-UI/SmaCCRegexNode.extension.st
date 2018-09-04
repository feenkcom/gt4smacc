Extension { #name : #SmaCCRegexNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCRegexNode >> testTokensDo: aBlock [
	leftParens do: aBlock.
	rightParens do: aBlock
]
