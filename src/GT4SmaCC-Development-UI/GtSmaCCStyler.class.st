Class {
	#name : #GtSmaCCStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'startingState',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #accessing }
GtSmaCCStyler >> grammarCoder [
	^ grammarCoder
]

{ #category : #accessing }
GtSmaCCStyler >> grammarCoder: aGrammarCoder [
	grammarCoder := aGrammarCoder
]

{ #category : #private }
GtSmaCCStyler >> initialize [
	super initialize.
	startingState := 1
]

{ #category : #private }
GtSmaCCStyler >> privateStyle: aText [
	[ | stylingVisitor |
	stylingVisitor := GtSmaCCCoderStylingVisitor new.
	stylingVisitor
		text: aText;
		styler: self;
		acceptNode:
			(SmaCCDefinitionParser
				parseWithErrors: aText asString
				startingAt: startingState) ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #accessing }
GtSmaCCStyler >> scannerClass [
	^ grammarCoder scannerClass
]

{ #category : #accessing }
GtSmaCCStyler >> startingState [
	^ startingState
]

{ #category : #accessing }
GtSmaCCStyler >> startingState: anInteger [
	startingState := anInteger
]
