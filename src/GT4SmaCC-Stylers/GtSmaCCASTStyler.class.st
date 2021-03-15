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
GtSmaCCASTStyler >> ast [
	^ parserClass
		parseWithErrors: text asString
		startingAt: self startingState
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
	[ self style: aText using: self ast ]
		on: Error
		do: [ :ex | ex return ].

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
GtSmaCCASTStyler >> style: aText using: anAST [
	text := aText.
	[ self styleAST: anAST ]
		ensure: [ text := nil ]
]

{ #category : #private }
GtSmaCCASTStyler >> styleAST: anAST [
]
