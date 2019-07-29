Class {
	#name : #GtSmaCCGrammar,
	#superclass : #GtSmaCCModel,
	#instVars : [
		'parserClassName',
		'scannerClassName',
		'rules',
		'originalAST',
		'glr',
		'caseInsensitive',
		'unicode'
	],
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #'instance creation' }
GtSmaCCGrammar class >> forDefinition: aString [
	^ self new
		source: aString;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCGrammar class >> onParser: aClass [
	^ self new
		parserClass: aClass;
		yourself
]

{ #category : #iterating }
GtSmaCCGrammar >> activeDirectivesDo: aBlock [
	self
		activeRulesDo: [ :each | 
			each isDirective
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #iterating }
GtSmaCCGrammar >> activeProductionsDo: aBlock [
	self
		activeRulesDo: [ :each | 
			each isProductionRule
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #iterating }
GtSmaCCGrammar >> activeRulesDo: aBlock [
	rules
		do: [ :each | 
			each isDeleted
				ifFalse: [ aBlock value: each ] ]
]

{ #category : #iterating }
GtSmaCCGrammar >> activeTokensDo: aBlock [
	self
		activeRulesDo: [ :each | 
			each isTokenRule
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #private }
GtSmaCCGrammar >> addGrammarItem: aNode [
	self addGrammarItem: aNode afterIndex: rules size
]

{ #category : #private }
GtSmaCCGrammar >> addGrammarItem: aNode afterIndex: anInteger [
	| item |
	aNode isDirective
		ifTrue: [ item := GtSmaCCDirective on: self ast: aNode ].
	aNode isTokenRule
		ifTrue: [ item := GtSmaCCTokenRule on: self ast: aNode ].
	aNode isProductionRule
		ifTrue: [ item := GtSmaCCProductionRule on: self ast: aNode ].
	item isNil
		ifTrue: [ ^ self ].
	rules add: item afterIndex: anInteger.
	item weak when: GtSmaCCGrammarAnnouncement send: #announce: to: self.
	self announce: (GtSmaCCGrammarRulesChanged forGrammar: self)
]

{ #category : #actions }
GtSmaCCGrammar >> addProductionNamed: aString [
	self addProductionNamed: aString for: nil
]

{ #category : #actions }
GtSmaCCGrammar >> addProductionNamed: aString for: aGrammarItem [
	| node |
	node := SmaCCDefinitionParser
		parse: (self productionRuleStringNamed: aString)
		startingAt: SmaCCDefinitionParser startingStateForProductionRule.
	self
		addGrammarItem: node
		afterIndex: (rules identityIndexOf: aGrammarItem ifAbsent: [ rules size ])
]

{ #category : #actions }
GtSmaCCGrammar >> addTokenNamed: aString [
	self addTokenNamed: aString for: nil
]

{ #category : #actions }
GtSmaCCGrammar >> addTokenNamed: aString for: aGrammarItem [
	| node |
	node := SmaCCDefinitionParser
		parseWithErrors: (self tokenDefinitionStringNamed: aString)
		startingAt: SmaCCDefinitionParser startingStateForRegexRule.
	self
		addGrammarItem: node
		afterIndex:
			(aGrammarItem isTokenRule
				ifTrue: [ (rules identityIndexOf: aGrammarItem ifAbsent: [ rules size ]) - 1 ]
				ifFalse: [ (rules size to: 1 by: -1)
						detect: [ :i | (rules at: i) isTokenRule or: [ (rules at: i) isDirective ] ]
						ifNone: [ 0 ] ])
]

{ #category : #iterating }
GtSmaCCGrammar >> allReferencesTo: aString do: aBlock [
	self
		activeRulesDo: [ :rule | 
			rule ast
				allNodesDo: [ :each | 
					((each isKindOf: SmaCCSymbolNode)
						or: [ each isKindOf: SmaCCTokenRegexNode ])
						ifTrue: [ each name source = aString
								ifTrue: [ aBlock value: each ] ] ] ]
]

{ #category : #accessing }
GtSmaCCGrammar >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtSmaCCGrammar >> ast [
	^ SmaCCDefinitionParser parseWithErrors: self source
]

{ #category : #private }
GtSmaCCGrammar >> caseInsensitiveDirective [
	self
		activeDirectivesDo: [ :each | 
			each isCaseInsensitive
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #actions }
GtSmaCCGrammar >> compileParser [
	SmaCCGrammarCompiler new
		buildDefinition: self source;
		compileInto: scannerClassName andParser: parserClassName
]

{ #category : #private }
GtSmaCCGrammar >> firstIndex [
	rules
		do:
			[ :each | each originalAST ifNotNil: [ :tree | ^ tree startPosition ] ].
	^ 1
]

{ #category : #private }
GtSmaCCGrammar >> glrDirective [
	self
		activeDirectivesDo: [ :each | 
			each isGLR
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCGrammar >> grammar [
	^ self
]

{ #category : #inspector }
GtSmaCCGrammar >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		stencil: [ (GtSmaCCGrammarCoder onGrammar: self) asElement ]
]

{ #category : #private }
GtSmaCCGrammar >> hasCaseInsensitiveDirective [
	^ self caseInsensitiveDirective notNil
]

{ #category : #private }
GtSmaCCGrammar >> hasGLRDirective [
	^ self glrDirective notNil
]

{ #category : #private }
GtSmaCCGrammar >> hasUnicodeDirective [
	^ self unicodeDirective notNil
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> initialize [
	super initialize.
	rules := OrderedCollection new.
	glr := false.
	caseInsensitive := false.
	unicode := false
]

{ #category : #testing }
GtSmaCCGrammar >> isCaseInsensitive [
	^ caseInsensitive
]

{ #category : #accessing }
GtSmaCCGrammar >> isCaseInsensitive: aBoolean [
	caseInsensitive := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isGLR [
	^ glr
]

{ #category : #accessing }
GtSmaCCGrammar >> isGLR: aBoolean [
	glr := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isModified [
	^ (rules anySatisfy: [ :each | each isModified ])
		or: [ glr ~= self hasGLRDirective
				or: [ unicode ~= self hasUnicodeDirective
						or: [ caseInsensitive ~= self hasCaseInsensitiveDirective ] ] ]
]

{ #category : #testing }
GtSmaCCGrammar >> isUnicode [
	^ unicode
]

{ #category : #accessing }
GtSmaCCGrammar >> isUnicode: aBoolean [
	unicode := aBoolean
]

{ #category : #testing }
GtSmaCCGrammar >> isValid [
	^ rules allSatisfy: [ :each | each isValid ]
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClass [
	^ Smalltalk at: parserClassName ifAbsent: [  ]
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> parserClass: aClass [
	parserClassName := aClass name.
	scannerClassName := [ aClass scannerClass name ]
		on: Error
		do: [ :ex | ex return ].
	originalAST := aClass definitionAST.
	originalAST isNil
		ifTrue: [ ^ self ].
	originalAST rules do: [ :each | self addGrammarItem: each ].
	glr := self hasGLRDirective.
	unicode := self hasUnicodeDirective.
	caseInsensitive := self hasCaseInsensitiveDirective
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClassName [
	^ parserClassName
]

{ #category : #accessing }
GtSmaCCGrammar >> parserClassName: anObject [
	parserClassName := anObject
]

{ #category : #private }
GtSmaCCGrammar >> productionRuleStringNamed: aString [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: aString;
				cr;
				tab;
				nextPut: $:;
				cr;
				tab;
				nextPut: $; ]
]

{ #category : #accessing }
GtSmaCCGrammar >> ruleNamed: aString [
	self
		activeRulesDo: [ :each | 
			each name = aString
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCGrammar >> rules [
	^ rules
]

{ #category : #accessing }
GtSmaCCGrammar >> rulesNamed: aString [
	| items |
	items := OrderedCollection new.
	self
		activeRulesDo: [ :each | 
			each name = aString
				ifTrue: [ items add: each ] ].
	^ items
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClass [
	^ (scannerClassName notNil
		ifTrue: [ Smalltalk at: scannerClassName ])
		ifNil: [ self parserClass
				ifNotNil: [ :cls | 
					[ cls scannerClass ]
						on: Error
						do: [ :ex | ex return ] ] ]
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClassName [
	^ scannerClassName
]

{ #category : #accessing }
GtSmaCCGrammar >> scannerClassName: anObject [
	scannerClassName := anObject
]

{ #category : #accessing }
GtSmaCCGrammar >> source [
	| newSource |
	self isModified
		ifFalse: [ ^ originalAST completeSource asString ].
	newSource := originalAST completeSource copy.
	self
		updateFlag: 'ignorecase'
		to: caseInsensitive
		directive: self caseInsensitiveDirective
		in: newSource.
	self
		updateFlag: 'unicode'
		to: unicode
		directive: self unicodeDirective
		in: newSource.
	self
		updateFlag: 'glr'
		to: glr
		directive: self glrDirective
		in: newSource.
	rules do: [ :each | each updateSource: newSource ].
	^ newSource asString
]

{ #category : #'initialize-release' }
GtSmaCCGrammar >> source: aString [
	originalAST := SmaCCDefinitionParser parseWithErrors: aString.
	originalAST isNil
		ifTrue: [ ^ self ].
	originalAST rules do: [ :each | self addGrammarItem: each ]
]

{ #category : #private }
GtSmaCCGrammar >> startDirectivesDo: aBlock [
	self
		activeDirectivesDo: [ :each | 
			each ast isStartDirective
				ifTrue: [ aBlock value: each ] ]
]

{ #category : #accessing }
GtSmaCCGrammar >> startingProductions [
	| startingNames productions first |
	startingNames := Set new.
	self
		startDirectivesDo: [ :each | startingNames addAll: (each ast symbols collect: #source) ].
	productions := OrderedCollection new.
	first := true.
	self
		activeProductionsDo: [ :each | 
			(first or: [ startingNames includes: each name ])
				ifTrue: [ productions add: each ].
			first := false ].
	^ productions
]

{ #category : #private }
GtSmaCCGrammar >> tokenDefinitionStringNamed: aString [
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: aString;
				cr;
				tab;
				nextPutAll: ': a';
				cr;
				tab;
				nextPut: $; ]
]

{ #category : #private }
GtSmaCCGrammar >> unicodeDirective [
	self
		activeDirectivesDo: [ :each | 
			each isUnicode
				ifTrue: [ ^ each ] ].
	^ nil
]

{ #category : #private }
GtSmaCCGrammar >> updateFlag: aString to: aBoolean directive: aRule in: aSmaCCString [
	aBoolean
		ifTrue: [ aRule isNil
				ifTrue: [ aSmaCCString
						insert: '%' , aString , ';' , String cr , String cr
						at: self firstIndex ] ]
		ifFalse: [ aRule notNil
				ifTrue: [ aSmaCCString
						deleteFrom: aRule originalAST startPosition
						to: aRule originalAST stopPosition ] ]
]
