Class {
	#name : #GtSmaCCSelectorFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'selector'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCSelectorFilter class >> selector: aString [
	^ self new
		selector: aString;
		yourself
]

{ #category : #testing }
GtSmaCCSelectorFilter >> matches: anObject [
	^ [ anObject perform: selector ] onDNU: selector do: [ :ex | false ]
]

{ #category : #accessing }
GtSmaCCSelectorFilter >> selector: aSymbol [
	selector := aSymbol
]
