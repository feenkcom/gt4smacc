Class {
	#name : #GtJSONListCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'itemCompleter'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONListCompleter >> completerForErrorNode: anErrorNode stackPointer: anInteger lastStackIndex: sizeInteger isLast: aBoolean [
	| token |
	token := SmaCCToken value: '['.
	anInteger
		to: sizeInteger
		do: [ :i | 
			token = (anErrorNode stackContents at: i)
				ifTrue: [ ^ itemCompleter
						completerForErrorNode: anErrorNode
						stackPointer: i + 1
						lastStackIndex: sizeInteger
						isLast: aBoolean ] ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONListCompleter >> completerForJSONNode: aJSONNode [
	(aJSONNode isKindOf: JSONArrayNode) ifTrue: [ ^ itemCompleter ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONListCompleter >> itemCompleter [
	^ itemCompleter
]

{ #category : #accessing }
GtJSONListCompleter >> itemCompleter: anObject [
	itemCompleter := anObject
]
