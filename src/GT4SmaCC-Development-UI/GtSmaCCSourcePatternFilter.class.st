Class {
	#name : #GtSmaCCSourcePatternFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'pattern'
	],
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCSourcePatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #accessing }
GtSmaCCSourcePatternFilter >> highlighter [
	^ GtSmaCCSourceHighlightingVisitor pattern: pattern
]

{ #category : #testing }
GtSmaCCSourcePatternFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem)
		ifFalse: [ ^ false ].
	pattern isEmpty
		ifTrue: [ ^ true ].
	^ (anObject source asLowercase
		indexOfSubCollection: pattern asLowercase) > 0
]

{ #category : #accessing }
GtSmaCCSourcePatternFilter >> pattern: aString [
	pattern := aString
]
