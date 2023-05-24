Class {
	#name : #GtJSONCompleter,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONCompleter class >> labelFor: aString withSearch: subString [
	| text attributes |
	attributes := {BlTextDecorationAttribute new
				color: BrGlamorousColors textHighlightColor;
				thickness: 3;
				underline}.
	text := aString asRopedText glamorousCodeFont.
	(text from: 1 to: subString size) attributes: attributes.
	^ text
]

{ #category : #accessing }
GtJSONCompleter >> complete: aString at: positionInteger hasQuote: aBoolean [
	^ #()
]

{ #category : #accessing }
GtJSONCompleter >> completerForErrorNode: anErrorNode stackPointer: anInteger lastStackIndex: sizeInteger isLast: aBoolean [ 
	^ aBoolean ifTrue: [ self ] ifFalse: [ GtJSONEmptyCompleter instance ]
]

{ #category : #accessing }
GtJSONCompleter >> completerForFinalJSONNode: aJSONNode [
	^ self
]

{ #category : #accessing }
GtJSONCompleter >> completerForFinalNode: aJSONNode at: positionInteger [
	aJSONNode isErrorNode
		ifTrue: [ | lastIndex |
			lastIndex := (aJSONNode stackContents size to: 1 by: -1)
					detect: [ :i | (self endIndexOf: aJSONNode at: i) <= positionInteger ]
					ifNone: [ aJSONNode stackContents size ].
			^ self
				completerForErrorNode: aJSONNode
				stackPointer: 1
				lastStackIndex: lastIndex
				isLast: true ].
	^ self completerForFinalJSONNode: aJSONNode
]

{ #category : #accessing }
GtJSONCompleter >> completerForJSONNode: aJSONNode [
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONCompleter >> completerForNode: aJSONNode at: positionInteger [
	aJSONNode isErrorNode
		ifTrue: [ | lastIndex |
			lastIndex := (aJSONNode stackContents size to: 1 by: -1)
					detect: [ :i | (self endIndexOf: aJSONNode at: i) <= positionInteger ]
					ifNone: [ aJSONNode stackContents size ].
			^ self
				completerForErrorNode: aJSONNode
				stackPointer: 1
				lastStackIndex: lastIndex
				isLast: false ].
	^ self completerForJSONNode: aJSONNode
]

{ #category : #accessing }
GtJSONCompleter >> endIndexOf: anErrorNode at: anInteger [
	| last |
	anErrorNode
		nodesAndTokensIn: (anErrorNode stackContents at: anInteger)
		do: [ :each | 
			last
				ifNil: [ last := each stopPosition ]
				ifNotNil: [ last := last max: each stopPosition ] ].
	^ last ifNil: [ SmallInteger maxVal ]
]

{ #category : #accessing }
GtJSONCompleter >> findCompleterFor: aJSONNode at: positionInteger [
	| allParents current |
	current := self.
	allParents := aJSONNode withAllParents.
	allParents size
		to: 1
		by: -1
		do: [ :i | 
			current := i = 1
					ifTrue: [ current completerForFinalNode: (allParents at: i) at: positionInteger ]
					ifFalse: [ current completerForNode: (allParents at: i) at: positionInteger ] ].
	^ current
]

{ #category : #accessing }
GtJSONCompleter >> labelFor: aString withSearch: subString [
	^ self class labelFor: aString withSearch: subString
]
