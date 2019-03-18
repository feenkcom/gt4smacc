Class {
	#name : #GtSmaCCGrammarCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'parserClass',
		'coders',
		'ast',
		'tokenCompletionStrategy',
		'productionCompletionStrategy'
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

{ #category : #accessing }
GtSmaCCGrammarCoder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #element }
GtSmaCCGrammarCoder >> asElement [
	^ GtSmaCCGrammarCoderElement onCoder: self
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> coderNamed: aString [
	^ coders
		detect: [ :each | each definitionName = aString ]
		ifNone: [  ]
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> coders [
	^ coders
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> initialize [
	super initialize.
	coders := OrderedCollection new.
	tokenCompletionStrategy := GtWeightedStringsCompletionStrategy new.
	productionCompletionStrategy := GtWeightedStringsCompletionStrategy
		new
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> parserClass: aClass [
	parserClass := aClass.
	parserClass isNil
		ifTrue: [ ^ self ].
	ast := parserClass definitionAST.
	ast isNil
		ifTrue: [ ^ self ].
	ast rules do: [ :each | self addCoderForRule: each ].
	self updateProductionCompletions.
	self updateTokenCompletions
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> productionCompletionStrategy [
	^ productionCompletionStrategy
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> scannerClass [
	^ [ parserClass scannerClass ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> source [
	| newSource |
	newSource := ast completeSource copy.
	coders do: [ :each | each updateSource: newSource ].
	^ newSource asString
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> sourceAST [
	^ SmaCCDefinitionParser parseWithErrors: self source
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> tokenCompletionStrategy [
	^ tokenCompletionStrategy
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateCompletions: aPrefixTree with: aNode [
	(GtSmaCCCompletionVisitor new completions: aPrefixTree) accept: aNode
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateProductionCompletions [
	| completions |
	completions := GtPrefixTree new.
	coders
		do: [ :each | 
			each isProductionRuleCoder
				ifTrue: [ self updateCompletions: completions with: each ast ] ].
	productionCompletionStrategy completions: completions
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateTokenCompletions [
	| completions |
	completions := GtPrefixTree new.
	coders
		do: [ :each | 
			each isTokenRuleCoder
				ifTrue: [ self updateCompletions: completions with: each ast ] ].
	tokenCompletionStrategy completions: completions
]
