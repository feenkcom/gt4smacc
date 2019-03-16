Class {
	#name : #GtSmaCCStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'startingState',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #formatting }
GtSmaCCStyler class >> formatCode: aText [
	aText foreground: Color darkGray
]

{ #category : #formatting }
GtSmaCCStyler class >> formatComment: aText [
	aText foreground: Color lightGray
]

{ #category : #formatting }
GtSmaCCStyler class >> formatDirective: aText [
	aText foreground: Color veryDarkGray
]

{ #category : #formatting }
GtSmaCCStyler class >> formatDirectiveKeyword: aText [
	aText bold
]

{ #category : #formatting }
GtSmaCCStyler class >> formatKeyword: aText [
	aText foreground: Color magenta
]

{ #category : #formatting }
GtSmaCCStyler class >> formatProduction: aText [
	aText foreground: Color purple
]

{ #category : #formatting }
GtSmaCCStyler class >> formatProductionDefinition: aText [
	aText bold.
	self formatProduction: aText
]

{ #category : #formatting }
GtSmaCCStyler class >> formatRepeat: aText [
	aText
		foreground: Color black;
		bold
]

{ #category : #formatting }
GtSmaCCStyler class >> formatToken: aText [
	aText foreground: Color blue
]

{ #category : #formatting }
GtSmaCCStyler class >> formatTokenDefinition: aText [
	aText bold.
	self formatToken: aText
]

{ #category : #formatting }
GtSmaCCStyler class >> formatVariableName: aText [
	aText foreground: Color gray
]

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
