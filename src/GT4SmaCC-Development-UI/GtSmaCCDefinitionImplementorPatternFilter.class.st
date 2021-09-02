Class {
	#name : 'GtSmaCCDefinitionImplementorPatternFilter',
	#superclass : 'GtSmaCCDefinitionsFilter',
	#instVars : [
		'pattern'
	],
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'instance creation' }
GtSmaCCDefinitionImplementorPatternFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : 'accessing' }
GtSmaCCDefinitionImplementorPatternFilter >> highlighter [
	^ GtSmaCCImplementorHighlightingVisitor pattern: pattern
]

{ #category : 'testing' }
GtSmaCCDefinitionImplementorPatternFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem)
		ifFalse: [ ^ false ].
	pattern isEmpty
		ifTrue: [ ^ true ].
	^ anObject name
		ifNil: [ false ]
		ifNotNil:
			[ :name | (name asLowercase indexOfSubCollection: pattern asLowercase) > 0 ]
]

{ #category : 'accessing' }
GtSmaCCDefinitionImplementorPatternFilter >> pattern: aString [
	pattern := aString
]
