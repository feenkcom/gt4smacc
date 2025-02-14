Class {
	#name : #GtSmaCCTransformationTextFilter,
	#superclass : #GtSmaCCTransformationFilesFilter,
	#instVars : [
		'text'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI-Filters'
}

{ #category : #testing }
GtSmaCCTransformationTextFilter >> matches: anObject [
	| string |
	string := self stringFor: anObject.
	string ifNil: [ ^ false ].
	self text isEmpty ifTrue: [ ^ true ].
	^ string includesSubstring: self text caseSensitive: false
]

{ #category : #private }
GtSmaCCTransformationTextFilter >> stringFor: anObject [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtSmaCCTransformationTextFilter >> text [
	^ text ifNil: [ '' ]
]

{ #category : #accessing }
GtSmaCCTransformationTextFilter >> text: anObject [
	text := anObject
]
