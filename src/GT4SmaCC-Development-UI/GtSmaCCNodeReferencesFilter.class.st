Class {
	#name : #GtSmaCCNodeReferencesFilter,
	#superclass : #GtSmaCCReferencesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCNodeReferencesFilter >> highlighterClass [
	^ GtSmaCCNodeReferencesHighlightingVisitor
]

{ #category : #testing }
GtSmaCCNodeReferencesFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCModel)
		ifFalse: [ ^ false ].
	anObject ast
		withAllNodesOfType: SmaCCClassProductionExpressionNode
		do: [ :each | 
			each nodeName = name
				ifTrue: [ ^ true ] ].
	^ false
]
