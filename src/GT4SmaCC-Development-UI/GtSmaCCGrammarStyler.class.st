Class {
	#name : #GtSmaCCGrammarStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'scannerClass',
		'originalGrammar',
		'completions'
	],
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #'instance creation' }
GtSmaCCGrammarStyler class >> for: aSmaCCScannerClass [
	^ self new
		scannerClass: aSmaCCScannerClass;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCGrammarStyler class >> for: aSmaCCScannerClass grammar: aSmaCCGrammarDefinitionNode [
	^ self new
		scannerClass: aSmaCCScannerClass;
		originalGrammar: aSmaCCGrammarDefinitionNode;
		yourself
]

{ #category : #stylers }
GtSmaCCGrammarStyler class >> stylerFor: aClass [
	<smaccStyler: #SmaCCDefinitionParser priority: 10>
	^ self new
]

{ #category : #accessing }
GtSmaCCGrammarStyler >> completions [
	^ completions
]

{ #category : #private }
GtSmaCCGrammarStyler >> initialize [
	super initialize.
	completions := GtPrefixTree new
]

{ #category : #accessing }
GtSmaCCGrammarStyler >> originalGrammar [
	^ originalGrammar
]

{ #category : #accessing }
GtSmaCCGrammarStyler >> originalGrammar: anObject [
	originalGrammar := anObject
]

{ #category : #private }
GtSmaCCGrammarStyler >> privateStyle: aText [
	[ | stylingVisitor |
	stylingVisitor := GtSmaCCGrammarStylingVisitor new.
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
GtSmaCCGrammarStyler >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
GtSmaCCGrammarStyler >> scannerClass: anObject [
	scannerClass := anObject
]
