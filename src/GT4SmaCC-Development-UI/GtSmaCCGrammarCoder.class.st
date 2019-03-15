Class {
	#name : #GtSmaCCGrammarCoder,
	#superclass : #Object,
	#instVars : [
		'parserClass',
		'coders',
		'ast'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCGrammarCoder class >> onParser: aClass [
	^ self new
		parserClass: aClass;
		yourself
]

{ #category : #private }
GtSmaCCGrammarCoder >> addCoderForRule: aNode [
	aNode isProductionRule
		ifTrue: [ coders add: (GtProductionCoder on: aNode in: self) ].
	aNode isTokenRule
		ifTrue: [ coders add: (GtTokenCoder on: aNode in: self) ]
]

{ #category : #element }
GtSmaCCGrammarCoder >> asElement [
	^ GtSmaCCGrammarCoderElement onCoder: self
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> coders [
	^ coders
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> initialize [
	super initialize.
	coders := OrderedCollection new
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> parserClass: aClass [
	parserClass := aClass.
	parserClass isNil
		ifTrue: [ ^ self ].
	ast := parserClass definitionAST.
	ast isNil
		ifTrue: [ ^ self ].
	ast rules do: [ :each | self addCoderForRule: each ]
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> scannerClass [
	^ [ parserClass scannerClass ]
		on: Error
		do: [ :ex | ex return ]
]
