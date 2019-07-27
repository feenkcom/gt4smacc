Class {
	#name : #GtSmaCCGrammarCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'grammar',
		'tokenCompletionStrategy',
		'productionCompletionStrategy',
		'group',
		'stylingProcess',
		'stylingQueue'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCGrammarCoder class >> onGrammar: aGrammar [
	^ self new
		grammar: aGrammar;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCGrammarCoder class >> onParser: parserClass [
	^ self onGrammar: (GtSmaCCGrammar onParser: parserClass)
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
	^ (self ruleNamed: aString)
		ifNotNil: [ :item | group coderFor: item ]
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> coders [
	^ group coders
]

{ #category : #actions }
GtSmaCCGrammarCoder >> compileParser [
	grammar compileParser
]

{ #category : #actions }
GtSmaCCGrammarCoder >> createRuleNamed: aString from: aCoder [
	aString first = $<
		ifTrue: [ grammar addTokenNamed: aString ]
		ifFalse: [ grammar addProductionNamed: aString ]
]

{ #category : #private }
GtSmaCCGrammarCoder >> deferStyle: aCoder [
	stylingQueue flushAllSuchThat: [ :each | each == aCoder ].
	stylingQueue nextPut: aCoder
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> grammar [
	^ grammar
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> grammar: aGrammar [
	grammar := aGrammar.
	self updateRuleList.
	grammar weak
		when: GtSmaCCGrammarAnnouncement
		send: #grammarChanged:
		to: self.
	self updateCompletions
]

{ #category : #events }
GtSmaCCGrammarCoder >> grammarChanged: grammarAnnouncement [
	(GtSmaCCGrammarRulesChanged handlesAnnouncement: grammarAnnouncement)
		ifTrue: [ self updateRuleList ].
	self announce: (GtSmaCCCoderAnnouncement new coder: self)
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> group [
	^ group
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> initialize [
	super initialize.
	group := GtSmaCCDefinitionGroupResult onCoder: self.
	tokenCompletionStrategy := GtSmaCCCompletionStrategy new.
	productionCompletionStrategy := GtSmaCCCompletionStrategy new.
	stylingQueue := SharedQueue new.
	self startStyler
]

{ #category : #testing }
GtSmaCCGrammarCoder >> isCaseInsensitive [
	^ grammar isCaseInsensitive
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> isCaseInsensitive: aBoolean [
	grammar isCaseInsensitive: aBoolean
]

{ #category : #testing }
GtSmaCCGrammarCoder >> isGLR [
	^ grammar isGLR
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> isGLR: aBoolean [
	grammar isGLR: aBoolean
]

{ #category : #testing }
GtSmaCCGrammarCoder >> isUnicode [
	^ grammar isUnicode
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> isUnicode: aBoolean [
	grammar isUnicode: aBoolean
]

{ #category : #testing }
GtSmaCCGrammarCoder >> isValid [
	^ grammar isValid
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> productionCompletionStrategy [
	^ productionCompletionStrategy
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> ruleNamed: aString [
	^ grammar ruleNamed: aString
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> rulesNamed: aString [
	^ grammar rulesNamed: aString
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> scannerClass [
	^ grammar scannerClass
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> source [
	^ grammar source
]

{ #category : #private }
GtSmaCCGrammarCoder >> startStyler [
	stylingProcess := [ [ stylingQueue next styleNow ] repeat ]
		forkAt: Processor userBackgroundPriority
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> tokenCompletionStrategy [
	^ tokenCompletionStrategy
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateCompletions [
	self updateProductionCompletions.
	self updateTokenCompletions
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateCompletions: aPrefixTree with: aNode [
	(GtSmaCCCompletionVisitor new completions: aPrefixTree) accept: aNode
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateProductionCompletions [
	| completions |
	completions := GtPrefixTree new.
	group
		do: [ :each | 
			each isProductionRule
				ifTrue: [ self updateCompletions: completions with: each ast ] ].
	productionCompletionStrategy completions: completions
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateRuleList [
	group updateItemsFrom: grammar rules
]

{ #category : #private }
GtSmaCCGrammarCoder >> updateTokenCompletions [
	| completions |
	completions := GtPrefixTree new.
	group
		do: [ :each | 
			each isTokenRule
				ifTrue: [ self updateCompletions: completions with: each ast ] ].
	tokenCompletionStrategy completions: completions
]
