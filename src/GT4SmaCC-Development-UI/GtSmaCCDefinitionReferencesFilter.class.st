Class {
	#name : #GtSmaCCDefinitionReferencesFilter,
	#superclass : #GtSmaCCReferencesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCDefinitionReferencesFilter >> highlighterClass [
	^ GtSmaCCDefinitionReferencesHighlightingVisitor
]

{ #category : #testing }
GtSmaCCDefinitionReferencesFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCModel)
		ifFalse: [ ^ false ].
	anObject ast
		withAllNodesDo: [ :each | 
			((each isKindOf: SmaCCSymbolNode)
				or: [ each isKindOf: SmaCCTokenRegexNode ])
				ifTrue: [ each name source = name
						ifTrue: [ ^ true ] ] ].
	^ false
]
