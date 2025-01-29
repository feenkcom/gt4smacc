Class {
	#name : #GtSmaCCDefinitionErrorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCDefinitionErrorFilter class >> filterDescriptor [
	^ GtFilterInvariableModel new
		name: 'Errors';
		creator: [ self new ];
		order: 100
]

{ #category : #testing }
GtSmaCCDefinitionErrorFilter >> matches: anObject [
	^ (anObject isKindOf: GtSmaCCGrammarItem)
		and: [ anObject isValid not ]
]
