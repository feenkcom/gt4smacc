Class {
	#name : #GtSmaCCDefinitionImplementorPatternFilter,
	#superclass : #GtSmaCCDefinitionImplementorFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCDefinitionImplementorPatternFilter class >> filterDescriptor [
	^ GtFilterTextModel new
		creator: [ :aString | self pattern: aString ];
		named: 'Name';
		order: 12
]

{ #category : #testing }
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
