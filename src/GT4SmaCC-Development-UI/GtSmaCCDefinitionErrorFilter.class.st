Class {
	#name : #GtSmaCCDefinitionErrorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #testing }
GtSmaCCDefinitionErrorFilter >> matches: anObject [
	^ (anObject isKindOf: GtSmaCCModel) and: [ anObject isValid not ]
]
