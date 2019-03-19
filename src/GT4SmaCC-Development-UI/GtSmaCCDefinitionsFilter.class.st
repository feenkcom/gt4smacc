Class {
	#name : #GtSmaCCDefinitionsFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCDefinitionsFilter class >> resultType [
	^ GtSmaCCDefinitionGroupResult
]

{ #category : #accessing }
GtSmaCCDefinitionsFilter >> highlighter [
	^ nil
]

{ #category : #testing }
GtSmaCCDefinitionsFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCCoder)
		ifFalse: [ ^ false ].
	anObject isProductionRuleCoder
		ifTrue: [ ^ self matchesProductionRule: anObject ].
	anObject isTokenRuleCoder
		ifTrue: [ ^ self matchesTokenRule: anObject ].
	^ false
]

{ #category : #testing }
GtSmaCCDefinitionsFilter >> matchesProductionRule: anObject [
	^ false
]

{ #category : #testing }
GtSmaCCDefinitionsFilter >> matchesTokenRule: anObject [
	^ false
]

{ #category : #accessing }
GtSmaCCDefinitionsFilter >> resultType [
	^ GtSmaCCDefinitionGroupResult
]
