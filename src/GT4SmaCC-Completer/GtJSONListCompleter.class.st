Class {
	#name : #GtJSONListCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'itemCompleter'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONListCompleter >> completerForErrorNode: anErrorNode stackPointer: anInteger isLast: aBoolean [
	| token |
	token := SmaCCToken value: '['.
	anInteger
		to: anErrorNode stackContents size
		do: [ :i | 
			token = (anErrorNode stackContents at: i)
				ifTrue: [ ^ itemCompleter
						completerForErrorNode: anErrorNode
						stackPointer: i + 1
						isLast: aBoolean ] ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONListCompleter >> completerForFinalNode: aJSONNode [
	aJSONNode isErrorNode
		ifTrue: [ (aJSONNode stackContents
				anySatisfy: [ :each | (each isKindOf: SmaCCToken) and: [ each value = '[' ] ])
				ifTrue: [ ^ itemCompleter ] ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONListCompleter >> completerForJSONNode: aJSONNode [
	(aJSONNode isKindOf: JSONArrayNode) ifTrue: [ ^ itemCompleter ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONListCompleter >> completerForNode: aJSONNode [
	(aJSONNode isKindOf: JSONArrayNode) ifTrue: [ ^ itemCompleter ].
	aJSONNode isErrorNode
		ifTrue: [ (aJSONNode stackContents
				anySatisfy: [ :each | (each isKindOf: SmaCCToken) and: [ each value = '[' ] ])
				ifTrue: [ ^ itemCompleter ] ].
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
