Class {
	#name : #GtSmaCCAmbiguousAction,
	#superclass : #Object,
	#instVars : [
		'parserClass'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #'instance creation' }
GtSmaCCAmbiguousAction class >> fromAction: anInteger in: aParser [
	| action parserClass |
	action := anInteger bitAnd: 2r11.
	parserClass := aParser class.
	parserClass isAnonymous ifTrue: [ parserClass := parserClass superclass ].
	action = 2r10
		ifTrue: [ ^ GtSmaCCAmbiguousReduceAction new
				parserClass: parserClass;
				action: anInteger;
				yourself ].
	action = 2r01
		ifTrue: [ ^ GtSmaCCAmbiguousShiftAction new
				parserClass: parserClass;
				tokenId: aParser currentToken ids first;
				yourself ].
	self error: 'Unknown action'
]

{ #category : #accessing }
GtSmaCCAmbiguousAction >> actionName [
	^ self subclassResponsibility
]

{ #category : #printing }
GtSmaCCAmbiguousAction >> gtDisplayOn: stream [
	stream << self actionName
]

{ #category : #accessing }
GtSmaCCAmbiguousAction >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtSmaCCAmbiguousAction >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #private }
GtSmaCCAmbiguousAction >> symbolNameFor: anInteger [
	^ parserClass symbolNames at: anInteger
]
