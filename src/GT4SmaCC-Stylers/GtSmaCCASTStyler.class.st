Class {
	#name : #GtSmaCCASTStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'parserClass',
		'startingState'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCASTStyler class >> forParser: aSmaCCParserClass [
	^ self new
		parserClass: aSmaCCParserClass;
		yourself
]

{ #category : #private }
GtSmaCCASTStyler >> astForText: aText [
	^ parserClass
		parseWithErrors: aText asString
		startingAt: self startingState
]

{ #category : #styling }
GtSmaCCASTStyler >> extraStyle: aText ast: anAST [
]

{ #category : #accessing }
GtSmaCCASTStyler >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtSmaCCASTStyler >> parserClass: aSmaCCParserClass [
	parserClass := aSmaCCParserClass
]

{ #category : #private }
GtSmaCCASTStyler >> privateStyle: aText [
	[
	self style: aText ast: (self astForText: aText) ]
		on: Error
		do: [ :ex |
			NonInteractiveTranscript stdout
				nextPut: $[;
				nextPutAll: self class name;
				nextPut: $];
				space;
				print: ex;
				cr.
			ex return ].

	^ aText
]

{ #category : #accessing }
GtSmaCCASTStyler >> startingState [
	^ startingState ifNil: [ parserClass defaultStartingState ]
]

{ #category : #accessing }
GtSmaCCASTStyler >> startingState: anInteger [
	startingState := anInteger
]

{ #category : #styling }
GtSmaCCASTStyler >> style: aText ast: anAST [
	text := aText.
	[ self styleAST: anAST ]
		ensure: [ text := nil ]
]

{ #category : #private }
GtSmaCCASTStyler >> styleAST: anAST [
]
