Class {
	#name : #GtSmaCCTransformationFilesFilter,
	#superclass : #GtSearchTypedEntitiesFilter,
	#instVars : [
		'toolkit'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #accessing }
GtSmaCCTransformationFilesFilter class >> availableFilters [
	| availableFilters |
	availableFilters := SortedCollection sortBlock: [ :a :b | a order < b order ].
	self
		withAllSubclassesDo: [ :each | each filterDescriptors do: [ :filter | availableFilters add: filter ] ].
	^ availableFilters
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter class >> filterDescriptor [
	^ nil
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter class >> filterDescriptors [
	^ self filterDescriptor ifNil: [ #() ] ifNotNil: [ :fd | {fd} ]
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter class >> resultType [
	^ GtSmaCCTransformationFilesGroupStream
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter >> defaultFilterScope [
	^ toolkit files asAsyncStream
]

{ #category : #'as yet unclassified' }
GtSmaCCTransformationFilesFilter >> matches: anObject [
	^ true
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter >> toolkit [
	^ toolkit
]

{ #category : #accessing }
GtSmaCCTransformationFilesFilter >> toolkit: anObject [
	toolkit := anObject
]
