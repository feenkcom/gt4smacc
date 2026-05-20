Class {
	#name : #GtSmaCCVariablesFilter,
	#superclass : #GtSmaCCVariableFilter,
	#instVars : [
		'names'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #testing }
GtSmaCCVariablesFilter >> matches: anObject [
	(anObject isKindOf: String) ifFalse: [ ^ false ].
	^ self names includes: anObject
]

{ #category : #accessing }
GtSmaCCVariablesFilter >> names [
	^ names ifNil: [ #() ]
]

{ #category : #accessing }
GtSmaCCVariablesFilter >> names: anObject [
	names := anObject
]
