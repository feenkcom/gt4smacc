Class {
	#name : 'GtSmaCCSelectorFilter',
	#superclass : 'GtSmaCCDefinitionsFilter',
	#instVars : [
		'selector'
	],
	#category : 'GT4SmaCC-Development-UI-Filters'
}

{ #category : 'instance creation' }
GtSmaCCSelectorFilter class >> selector: aString [
	^ self new
		selector: aString;
		yourself
]

{ #category : 'testing' }
GtSmaCCSelectorFilter >> matches: anObject [
	^ (anObject respondsTo: selector) and: [ anObject perform: selector ]
]

{ #category : 'accessing' }
GtSmaCCSelectorFilter >> selector: aSymbol [
	selector := aSymbol
]
