Extension { #name : #SmaCCProductionSymbolNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCProductionSymbolNode >> definition [
	^ self topParent rules
		detect: [ :each | (each isKindOf: SmaCCProductionRuleNode) and: [ each name = name ] ]
		ifNone: [ nil ]
]
