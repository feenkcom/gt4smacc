Class {
	#name : #GtSmaCCNameDefinitionFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'names'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'as yet unclassified' }
GtSmaCCNameDefinitionFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem) ifFalse: [ ^ false ].
	^ self names includes: anObject name
]

{ #category : #accessing }
GtSmaCCNameDefinitionFilter >> names [
	^ names ifNil: [ #() ]
]

{ #category : #accessing }
GtSmaCCNameDefinitionFilter >> names: anObject [
	names := anObject
]
