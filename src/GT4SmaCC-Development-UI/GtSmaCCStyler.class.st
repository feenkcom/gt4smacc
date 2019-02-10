Class {
	#name : #GtSmaCCStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'scannerClass',
		'originalGrammar',
		'completions'
	],
	#category : #'GT4SmaCC-Development-UI'
}

{ #category : #'instance creation' }
GtSmaCCStyler class >> for: aSmaCCScannerClass [
	^ self new
		scannerClass: aSmaCCScannerClass;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCStyler class >> for: aSmaCCScannerClass grammar: aSmaCCGrammarDefinitionNode [
	^ self new
		scannerClass: aSmaCCScannerClass;
		originalGrammar: aSmaCCGrammarDefinitionNode;
		yourself
]

{ #category : #accessing }
GtSmaCCStyler >> completions [
	^ completions
]

{ #category : #'initialize-release' }
GtSmaCCStyler >> initialize [
	super initialize.
	completions := GtPrefixTree new
]

{ #category : #accessing }
GtSmaCCStyler >> originalGrammar [
	^ originalGrammar
]

{ #category : #accessing }
GtSmaCCStyler >> originalGrammar: anObject [
	originalGrammar := anObject
]

{ #category : #private }
GtSmaCCStyler >> privateStyle: aText [
	[ | stylingVisitor |
	stylingVisitor := GtSmaCCStylingVisitor new.
	aText
		attributes:
			{BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BlTextForegroundAttribute new paint: Color darkGray darker)}.
	stylingVisitor
		text: aText;
		styler: self;
		acceptNode: (SmaCCDefinitionParser parseWithErrors: aText asString).
	completions := stylingVisitor completions ]
		on: Error
		do: [ :ex | ex return ].
	^ aText
]

{ #category : #accessing }
GtSmaCCStyler >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
GtSmaCCStyler >> scannerClass: anObject [
	scannerClass := anObject
]
