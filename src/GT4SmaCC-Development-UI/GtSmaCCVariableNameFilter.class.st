Class {
	#name : #GtSmaCCVariableNameFilter,
	#superclass : #GtSmaCCVariableFilter,
	#instVars : [
		'pattern'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCVariableNameFilter class >> pattern: aString [
	^ self new
		pattern: aString;
		yourself
]

{ #category : #testing }
GtSmaCCVariableNameFilter >> matches: anObject [
	(anObject isKindOf: String) ifFalse: [ ^ false ].
	pattern isEmpty ifTrue: [ ^ true ].
	^ (anObject asLowercase indexOfSubCollection: pattern asLowercase) > 0
]

{ #category : #accessing }
GtSmaCCVariableNameFilter >> pattern: anObject [
	pattern := anObject
]
