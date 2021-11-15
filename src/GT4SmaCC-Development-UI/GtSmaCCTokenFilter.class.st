Class {
	#name : #GtSmaCCTokenFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : #testing }
GtSmaCCTokenFilter >> matches: anObject [
	^ anObject isKindOf: GtSmaCCTokenRule
]
