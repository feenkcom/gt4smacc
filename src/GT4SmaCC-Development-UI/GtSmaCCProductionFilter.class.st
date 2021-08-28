Class {
	#name : 'GtSmaCCProductionFilter',
	#superclass : 'GtSmaCCDefinitionsFilter',
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'testing' }
GtSmaCCProductionFilter >> matches: anObject [
	^ anObject isKindOf: GtSmaCCProductionRule
]
