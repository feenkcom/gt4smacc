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
		'completionsProcess',
		'variableGroup'
	],
	#category : 'GT4SmaCC-Development-UI-Coders'
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

{ #category : #element }
GtSmaCCGrammarCoder >> addMenuItems [
	| items |
	items := OrderedCollection new.
	items add: #('<token>' #addToken).
	items add: #('Production' #addProduction).
	(grammar hasDirectiveNamed: 'root')
		ifFalse: [ items add: #('%root' #addRoot) ].
	(grammar hasDirectiveNamed: 'prefix')
		ifFalse: [ items add: #('%prefix' #addPrefix) ].
	(grammar hasDirectiveNamed: 'suffix')
		ifFalse: [ items add: #('%suffix' #addSuffix) ].
	items add: #('%attributes' #addAttributes).
	(grammar hasDirectiveNamed: 'ignore_variables')
		ifFalse: [ items add: #('%ignore_variables' #addIgnoreVariables) ].
	items add: #('%hierarchy' #addHierarchy).
	(grammar hasDirectiveNamed: 'start')
		ifFalse: [ items add: #('%start' #addStart) ].
	items add: #('%left/right/nonassoc' #addLeft).
	(grammar hasDirectiveNamed: 'id')
		ifFalse: [ items add: #('%id' #addId) ].
	(grammar hasDirectiveNamed: 'scopes')
		ifFalse: [ items add: #('%scopes' #addScopes) ].
	(grammar hasDirectiveNamed: 'excludes')
		ifFalse: [ items add: #('%excludes' #addExcludes) ].
	^ items
]

{ #category : #element }
GtSmaCCGrammarCoder >> addMenuItemsElement [
	^ GtCoderContextMenuContent new
		constraintsDo: [ :c | c horizontal matchParent ];
		editorElement: self;
		items:
			(self addMenuItems
				collect: [ :each | 
					GtCoderContextMenuAction new
						action: [ :element | grammar perform: each second ];
						title: each first ]);
		hMatchParent;
		vMatchParent
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #element }
GtSmaCCGrammarCoder >> asElement [
	^ GtSmaCCGrammarCoderElement onCoder: self
]

{ #category : #element }
GtSmaCCGrammarCoder >> asVariableElement [
	^ GtSmaCCGrammarVariableCoderElement onCoder: self
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
	^ aString first = $<
		ifTrue: [ grammar addTokenNamed: aString for: aCoder grammarItem ]
		ifFalse: [ grammar addProductionNamed: aString for: aCoder grammarItem ]
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
	self updateItems
]

{ #category : #events }
GtSmaCCGrammarCoder >> grammarChanged: grammarAnnouncement [
	| announcementClass |
	(GtSmaCCGrammarRulesChanged handlesAnnouncement: grammarAnnouncement)
		ifTrue: [ self updateRuleList.
			announcementClass := GtSmaCCCoderRulesChangedAnnouncement ]
		ifFalse: [ announcementClass := GtSmaCCCoderAnnouncement ].
	self announce: (announcementClass forCoder: self)
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> group [
	^ group
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoder >> initialize [
	super initialize.
	group := GtSmaCCDefinitionGroupResult onCoder: self.
	variableGroup := GtSmaCCVariableGroupResult onCoder: self.
	tokenCompletionStrategy := GtSmaCCCompletionStrategy new.
	productionCompletionStrategy := GtSmaCCCompletionStrategy new
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

{ #category : #accessing }
GtSmaCCGrammarCoder >> textualCoderViewModel [
	^ self
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
GtSmaCCGrammarCoder >> updateItems [
	completionsProcess notNil
		ifTrue: [ completionsProcess terminate ].
	completionsProcess := [ (Delay forMilliseconds: 50) wait.
	self updateVariableItems.
	self updateCompletions.
	completionsProcess := nil ] forkAt: Processor userBackgroundPriority
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

{ #category : #events }
GtSmaCCGrammarCoder >> updateStylingForRenameFrom: oldName to: newName [
	self coders
		do: [ :each | 
			| source |
			source := each source.
			((oldName notNil and: [ source includesSubstring: oldName ])
				or: [ newName notNil and: [ source includesSubstring: newName ] ])
				ifTrue: [ each styleSource ] ]
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

{ #category : #private }
GtSmaCCGrammarCoder >> updateVariableItems [
	variableGroup updateItems: grammar allItemNames
]

{ #category : #accessing }
GtSmaCCGrammarCoder >> variableGroup [
	^ variableGroup
]
