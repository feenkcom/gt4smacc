Class {
	#name : 'GtSmaCCVariableReferencesFilter',
	#superclass : 'GtSmaCCReferencesFilter',
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'accessing' }
GtSmaCCVariableReferencesFilter >> highlighterClass [
	^ GtSmaCCVariableReferencesHighlightingVisitor
]

{ #category : 'testing' }
GtSmaCCVariableReferencesFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem)
		ifFalse: [ ^ false ].
	anObject ast
		withAllNodesOfType: SmaCCSymbolNode
		do: [ :each | 
			(each variableNameToken notNil
				and: [ each variableNameToken source = name ])
				ifTrue: [ ^ true ] ].
	^ false
]
