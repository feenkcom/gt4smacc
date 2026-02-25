Class {
	#name : #GtSmaCCParserExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #private }
GtSmaCCParserExamples >> fail: aString [
	^ [ self parserClass parse: aString.
	self assert: 'No error was raised' ]
		on: SmaCCParserError
		do: [ :ex | ^ ex freeze ]
]

{ #category : #private }
GtSmaCCParserExamples >> parse: aString [
	^ self parserClass parse: aString
]

{ #category : #private }
GtSmaCCParserExamples >> parse: aString startingAt: anInteger [
	^ self parserClass parse: aString startingAt: anInteger
]

{ #category : #accessing }
GtSmaCCParserExamples >> parserClass [
	self subclassResponsibility
]
