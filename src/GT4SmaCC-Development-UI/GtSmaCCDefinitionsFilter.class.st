Class {
	#name : #GtSmaCCDefinitionsFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #accessing }
GtSmaCCDefinitionsFilter class >> availableFilters [
	| availableFilters |
	availableFilters := SortedCollection sortBlock: [ :a :b | a order < b order ].
	self
		withAllSubclassesDo: [ :each | each filterDescriptors do: [ :filter | availableFilters add: filter ] ].
	^ availableFilters
]

{ #category : #accessing }
GtSmaCCDefinitionsFilter class >> filterDescriptor [
	^ nil
]

{ #category : #accessing }
GtSmaCCDefinitionsFilter class >> filterDescriptors [
	^ self filterDescriptor ifNotNil: [ :each | {each} ] ifNil: [ #() ]
]

{ #category : #accessing }
GtSmaCCDefinitionsFilter class >> resultType [
	^ GtSmaCCDefinitionGroupResult
]
