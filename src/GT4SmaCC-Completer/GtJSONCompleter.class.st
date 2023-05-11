Class {
	#name : #GtJSONCompleter,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONCompleter >> complete: aString at: positionInteger [
	^ #()
]

{ #category : #accessing }
GtJSONCompleter >> completerForErrorNode: anErrorNode stackPointer: anInteger isLast: aBoolean [
	^ aBoolean ifTrue: [ self ] ifFalse: [ GtJSONEmptyCompleter instance ]
]

{ #category : #accessing }
GtJSONCompleter >> completerForFinalJSONNode: aJSONNode [
	^ self
]

{ #category : #accessing }
GtJSONCompleter >> completerForFinalNode: aJSONNode [
	aJSONNode isErrorNode
		ifTrue: [ ^ self
				completerForErrorNode: aJSONNode
				stackPointer: 1
				isLast: true ].
	^ self completerForFinalJSONNode: aJSONNode
]

{ #category : #accessing }
GtJSONCompleter >> completerForJSONNode: aJSONNode [
	^ GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONCompleter >> completerForNode: aJSONNode [
	aJSONNode isErrorNode
		ifTrue: [ ^ self
				completerForErrorNode: aJSONNode
				stackPointer: 1
				isLast: false ].
	^ self completerForJSONNode: aJSONNode
]

{ #category : #accessing }
GtJSONCompleter >> findCompleterFor: aJSONNode [
	| allParents current |
	current := self.
	allParents := aJSONNode withAllParents.
	allParents size
		to: 1
		by: -1
		do: [ :i | 
			current := i = 1
					ifTrue: [ current completerForFinalNode: (allParents at: i) ]
					ifFalse: [ current completerForNode: (allParents at: i) ] ].
	^ current
]

{ #category : #accessing }
GtJSONCompleter >> labelFor: aString withSearch: subString [
	| text attributes |
	attributes := {BlTextDecorationAttribute new
				color: BrGlamorousColors textHighlightColor;
				thickness: 3;
				underline}.
	text := aString asRopedText glamorousCodeFont.
	(text from: 1 to: subString size) attributes: attributes.
	^ text
]
