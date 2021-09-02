Extension { #name : 'SmaCCTokenRegexNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCTokenRegexNode >> definition [
	^ self topParent rules detect: [ :each | (each isKindOf: SmaCCTokenRuleNode) and: [ each name = name ] ] ifNone: [ nil ]
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCTokenRegexNode >> testTokensDo: aBlock [
	super testTokensDo: aBlock.
	aBlock value: name
]
