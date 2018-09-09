Class {
	#name : #FkSmaCCStyler,
	#superclass : #BrTextStyler,
	#instVars : [
		'scannerClass',
		'originalGrammar',
		'completions'
	],
	#category : #'GT-SmaCC-Development-UI'
}

{ #category : #'instance creation' }
FkSmaCCStyler class >> for: aSmaCCScannerClass [
	^ self new
		scannerClass: aSmaCCScannerClass;
		yourself
]

{ #category : #'instance creation' }
FkSmaCCStyler class >> for: aSmaCCScannerClass grammar: aSmaCCGrammarDefinitionNode [
	^ self new
		scannerClass: aSmaCCScannerClass;
		originalGrammar: aSmaCCGrammarDefinitionNode;
		yourself
]

{ #category : #accessing }
FkSmaCCStyler >> completions [
	^ completions
]

{ #category : #'initialize-release' }
FkSmaCCStyler >> initialize [
	super initialize.
	completions := GtPrefixTree new
]

{ #category : #accessing }
FkSmaCCStyler >> originalGrammar [
	^ originalGrammar
]

{ #category : #accessing }
FkSmaCCStyler >> originalGrammar: anObject [
	originalGrammar := anObject
]

{ #category : #private }
FkSmaCCStyler >> privateStyle: aText [
	[ | stylingVisitor |
	stylingVisitor := FkSmaCCStylingVisitor new.
	aText
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrTextForegroundAttribute new paint: Color darkGray darker)}.
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
FkSmaCCStyler >> scannerClass [
	^ scannerClass
]

{ #category : #accessing }
FkSmaCCStyler >> scannerClass: anObject [
	scannerClass := anObject
]
