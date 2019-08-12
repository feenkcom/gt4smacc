Class {
	#name : #GtSmaCCStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'startingState',
		'coder'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #formatting }
GtSmaCCStyler class >> formatAST: aText [
	aText foreground: Color green muchDarker
]

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
GtSmaCCStyler class >> formatMissing: aText [
	aText foreground: Color red
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
	aText foreground: Color green muchDarker lighter
]

{ #category : #accessing }
GtSmaCCStyler >> coder [
	^ coder
]

{ #category : #accessing }
GtSmaCCStyler >> coder: smaccCoder [
	coder := smaccCoder
]

{ #category : #accessing }
GtSmaCCStyler >> grammarCoder [
	^ coder owner
]

{ #category : #'initialize-release' }
GtSmaCCStyler >> initialize [
	super initialize.
	startingState := 1.
	delay := 0 seconds
]

{ #category : #private }
GtSmaCCStyler >> privateStyle: aText [
	[ | ast |
	text := aText.
	ast := SmaCCDefinitionParser
		parseWithErrors: aText asString
		startingAt: startingState.
	coder highlighter
		ifNotNil: [ :highlighter | highlighter styleNode: ast using: self ].
	self syntaxStylingVisitor styleNode: ast using: self ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #accessing }
GtSmaCCStyler >> scannerClass [
	^ self grammarCoder scannerClass
]

{ #category : #accessing }
GtSmaCCStyler >> startingState [
	^ startingState
]

{ #category : #accessing }
GtSmaCCStyler >> startingState: anInteger [
	startingState := anInteger
]

{ #category : #private }
GtSmaCCStyler >> syntaxStylingVisitor [
	^ GtSmaCCCoderStylingVisitor new
]

{ #category : #accessing }
GtSmaCCStyler >> text [
	^ text
]
