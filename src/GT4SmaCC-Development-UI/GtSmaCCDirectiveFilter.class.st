Class {
	#name : #GtSmaCCDirectiveFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : #testing }
GtSmaCCDirectiveFilter >> matches: anObject [
	^ anObject isKindOf: GtSmaCCDirective
]
