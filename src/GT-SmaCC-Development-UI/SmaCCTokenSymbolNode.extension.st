Extension { #name : #SmaCCTokenSymbolNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCTokenSymbolNode >> definition [
	^ self topParent rules
		detect: [ :each | (each isKindOf: SmaCCTokenRuleNode) and: [ each name = name ] ]
		ifNone: [ nil ]
]
