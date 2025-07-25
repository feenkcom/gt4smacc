Class {
	#name : #GtSmaCCDefinitionImplementorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCDefinitionImplementorFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCDefinitionImplementorFilter >> highlighter [
	^ GtSmaCCImplementorHighlightingVisitor pattern: pattern
]

{ #category : #testing }
GtSmaCCDefinitionImplementorFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem) ifFalse: [ ^ false ].
	pattern isEmpty ifTrue: [ ^ true ].
	^ anObject name = pattern
]

{ #category : #accessing }
GtSmaCCDefinitionImplementorFilter >> pattern: aString [
	pattern := aString
]
