Class {
	#name : #GtSmaCCCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'grammarItem',
		'owner',
		'expanded',
		'collapsedEditor',
		'sourceEditor',
		'attributes'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #private }
GtSmaCCCoder class >> coderClassFor: anItem [
	anItem isProductionRule
		ifTrue: [ ^ GtSmaCCProductionCoder ].
	anItem isTokenRule
		ifTrue: [ ^ GtSmaCCTokenCoder ].
	anItem isDirective
		ifTrue:
			[ (#(isAssociativeDirective isAttributeDirective isIdDirective isIgnoreDirective isHierarchyDirective isStartDirective)
				anySatisfy: [ :each | anItem ast perform: each ])
				ifTrue: [ ^ GtSmaCCDirectiveCoder ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCCoder class >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro')
		beNotOverwritableByStyler.
	BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}
]

{ #category : #'instance creation' }
GtSmaCCCoder class >> on: aGrammarItem in: aGrammarCoder [
	| class |
	class := self coderClassFor: aGrammarItem.
	class isNil
		ifTrue: [ ^ nil ].
	^ class new
		owner: aGrammarCoder;
		grammarItem: aGrammarItem;
		yourself
]

{ #category : #actions }
GtSmaCCCoder >> actions [
	^ #()
]

{ #category : #actions }
GtSmaCCCoder >> addShortcutsTo: editorElement [
	self shortcuts
		do: [ :each | 
			editorElement
				addShortcut: (each copy action: [ each action cull: editorElement ]) ]
]

{ #category : #accessing }
GtSmaCCCoder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #elements }
GtSmaCCCoder >> asElement [
	^ GtSmaCCCoderElement onCoder: self
]

{ #category : #accessing }
GtSmaCCCoder >> ast [
	^ grammarItem ast
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: [  ] ]
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol ifAbsent: aBlock [
	^ attributes notNil
		ifTrue: [ attributes at: aSymbol ifAbsent: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol ifAbsentPut: aBlock [
	^ self attributes at: aSymbol ifAbsentPut: aBlock
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributeNamed: aSymbol put: anObject [
	^ self attributes at: aSymbol put: anObject
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> attributes [
	^ attributes ifNil: [ attributes := IdentityDictionary new ]
]

{ #category : #accessing }
GtSmaCCCoder >> badgeTypes [
	^ #()
]

{ #category : #accessing }
GtSmaCCCoder >> badges [
	| items |
	items := OrderedCollection new.
	self badgeTypes
		do: [ :each | 
			(grammarItem perform: each last)
				ifTrue: [ items add: each first ] ].
	^ items
]

{ #category : #actions }
GtSmaCCCoder >> browseReferences: anElement [
	| filter |
	filter := self referencesFilterAtCursor.
	filter isNil
		ifTrue: [ ^ self ].
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (GtSmaCCGrammarFilter on: self owner) & filter;
				sourceElement: anElement)
]

{ #category : #'private-actions' }
GtSmaCCCoder >> coderRenamePositionsForProduction: aSmaCCToken [
	| coderMap |
	coderMap := Dictionary new.
	owner coders
		do: [ :each | 
			each isProductionRule
				ifTrue: [ | tokenBlock |
					tokenBlock := [ :token | 
					token = aSmaCCToken
						ifTrue: [ (coderMap at: each ifAbsentPut: [ OrderedCollection new ])
								add: token sourceInterval ] ].
					tokenBlock value: each ast name.
					each ast
						allNodesOfType: SmaCCProductionRuleNode
						do: [ :node | tokenBlock value: node name ].
					each ast
						allNodesOfType: SmaCCProductionSymbolNode
						do: [ :node | tokenBlock value: node name ] ].
			each isDirective
				ifTrue: [ ((each ast isKindOf: SmaCCAssociativeDirectiveNode)
						or: [ each ast isKindOf: SmaCCStartDirectiveNode ])
						ifTrue: [ each ast symbols
								do: [ :token | 
									token = aSmaCCToken
										ifTrue: [ (coderMap at: each ifAbsentPut: [ OrderedCollection new ])
												add: token sourceInterval ] ] ] ] ].
	^ coderMap
]

{ #category : #'private-actions' }
GtSmaCCCoder >> coderRenamePositionsForToken: aSmaCCToken [
	| coderMap |
	coderMap := Dictionary new.
	owner coders
		do: [ :each | 
			each ast
				allNodesDo: [ :node |  ]
				andTokensDo: [ :token | 
					token = aSmaCCToken
						ifTrue: [ (coderMap at: each ifAbsentPut: [ OrderedCollection new ])
								add: (token startPosition + 1 to: token stopPosition - 1) ] ] ].
	^ coderMap
]

{ #category : #editor }
GtSmaCCCoder >> collapsedEditor [
	collapsedEditor isNil
		ifTrue: [ collapsedEditor := self newCollapsedEditor.
			self updateCollapsedSource ].
	^ collapsedEditor
]

{ #category : #accessing }
GtSmaCCCoder >> collapsedText [
	^ self name asRopedText
]

{ #category : #accessing }
GtSmaCCCoder >> completionStrategy [
	grammarItem isProductionRule
		ifTrue: [ ^ self productionCompletionStrategy ].
	grammarItem isTokenRule
		ifTrue: [ ^ self tokenCompletionStrategy ].
	^ nil
]

{ #category : #editor }
GtSmaCCCoder >> defaultTextAttributes [
	^ self class defaultTextAttributes
]

{ #category : #actions }
GtSmaCCCoder >> deleteRule [
	self
		executeTransformation: (GtSmaCCDeleteRefactoring delete: grammarItem)
]

{ #category : #private }
GtSmaCCCoder >> disableCodeCompletion [
	self productionCompletionStrategy disable.
	self tokenCompletionStrategy disable
]

{ #category : #private }
GtSmaCCCoder >> enableCodeCompletion [
	self productionCompletionStrategy enable.
	self tokenCompletionStrategy enable
]

{ #category : #'private-actions' }
GtSmaCCCoder >> executeTransformation: aSmaCCTransformation [
	[ aSmaCCTransformation execute ]
		on: GtSmaCCTransformationError
		do: [ :ex | self inform: ex messageText ]
]

{ #category : #accessing }
GtSmaCCCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtSmaCCCoder >> expanded: aBoolean [
	expanded := aBoolean
]

{ #category : #accessing }
GtSmaCCCoder >> grammar [
	^ self grammarItem grammar
]

{ #category : #accessing }
GtSmaCCCoder >> grammarItem [
	^ grammarItem
]

{ #category : #accessing }
GtSmaCCCoder >> grammarItem: aGrammarItem [
	grammarItem notNil
		ifTrue: [ grammarItem announcer unsubscribe: self ].
	grammarItem := aGrammarItem.
	grammarItem notNil
		ifTrue: [ grammarItem weak
				subscribe: GtSmaCCGrammarItemChanged
				send: #itemChanged:
				to: self ]
]

{ #category : #accessing }
GtSmaCCCoder >> highlighter [
	^ self attributeNamed: #highlighter
]

{ #category : #accessing }
GtSmaCCCoder >> highlighter: aHighlightingVisitor [
	self attributeNamed: #highlighter put: aHighlightingVisitor.
	self styleSource
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> initialize [
	super initialize.
	expanded := false
]

{ #category : #'private-actions' }
GtSmaCCCoder >> installRenameActionOn: anElement forCoders: coderIntervalMap [
	| renameAction localIntervals local |
	local := coderIntervalMap keys
		detect: [ :each | self grammarItem == each grammarItem ]
		ifNone: [ ^ self ].
	localIntervals := coderIntervalMap at: local.
	coderIntervalMap removeKey: local.
	renameAction := GtCompositeRenameAction
		locations: localIntervals
		element: anElement.
	coderIntervalMap
		keysAndValuesDo: [ :coder :tokens | 
			renameAction
				addLocations: (tokens collect: [ :each | each first ])
				to: coder sourceEditor ].
	self disableCodeCompletion.
	renameAction
		when: GtRenameActionAnnoucement
		do: [ :ann | 
			ann eventType = #uninstall
				ifTrue: [ self enableCodeCompletion ] ].
	renameAction install
]

{ #category : #testing }
GtSmaCCCoder >> isDirective [
	^ grammarItem isDirective
]

{ #category : #private }
GtSmaCCCoder >> isInterval: interval inside: aNodeOrToken [
	^ interval first >= aNodeOrToken startPosition
		and: [ interval last <= aNodeOrToken stopPosition ]
]

{ #category : #testing }
GtSmaCCCoder >> isModified [
	^ grammarItem isModified
]

{ #category : #testing }
GtSmaCCCoder >> isProductionRule [
	^ grammarItem isProductionRule
]

{ #category : #testing }
GtSmaCCCoder >> isReferenced [
	^ grammarItem isReferenced
]

{ #category : #testing }
GtSmaCCCoder >> isTokenRule [
	^ grammarItem isTokenRule
]

{ #category : #testing }
GtSmaCCCoder >> isValid [
	^ grammarItem isValid
]

{ #category : #private }
GtSmaCCCoder >> itemChanged: anAnnouncement [
	grammarItem source ~= self sourceEditor text asString
		ifTrue: [ self sourceEditor text: self sourceText.
			self updateCollapsedSource ]
]

{ #category : #accessing }
GtSmaCCCoder >> name [
	^ grammarItem name
]

{ #category : #editor }
GtSmaCCCoder >> newCollapsedEditor [
	^ BrTextEditor new
]

{ #category : #editor }
GtSmaCCCoder >> newSourceEditor [
	^ BrTextEditor new
		text: self sourceText;
		styler: self newStyler;
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ];
		when: BlInfiniteDataSourceChanged
			do: [ :event | self sourceChanged ];
		yourself
]

{ #category : #editor }
GtSmaCCCoder >> newStyler [
	^ GtSmaCCStyler new
		coder: self;
		yourself
]

{ #category : #private }
GtSmaCCCoder >> nodeAtCursor [
	self nodeForSelectionDo: [ :each | ^ each ].
	^ nil
]

{ #category : #private }
GtSmaCCCoder >> nodeForSelectionDo: aBlock [
	| node interval |
	interval := self selectedSourceInterval.
	interval isNil
		ifTrue: [ ^ self ].
	node := nil.
	self ast
		withAllNodesDo: [ :each | 
			(self isInterval: interval inside: each)
				ifTrue: [ node := each ] ].
	node notNil
		ifTrue: [ aBlock cull: node cull: interval ]
]

{ #category : #private }
GtSmaCCCoder >> nodesForInterval: interval in: aNode [
	| nodes |
	nodes := OrderedCollection new.
	aNode
		nodesDo: [ :each | 
			(each startPosition >= interval first
				and: [ each stopPosition <= interval last ])
				ifTrue: [ nodes add: each ]
				ifFalse: [ (each startPosition <= interval first
						and: [ each stopPosition >= interval last ])
						ifTrue: [ ^ self nodesForInterval: interval in: each ]
						ifFalse: [ (each startPosition > interval last
								or: [ each stopPosition < interval first ])
								ifFalse: [ ^ #() ] ] ] ].
	^ nodes
]

{ #category : #private }
GtSmaCCCoder >> nodesForSelection [
	| interval |
	interval := self selectedSourceInterval.
	interval isNil
		ifTrue: [ ^ #() ].
	^ self nodesForInterval: interval in: self ast
]

{ #category : #accessing }
GtSmaCCCoder >> owner [
	^ owner
]

{ #category : #'initialize-release' }
GtSmaCCCoder >> owner: aGrammarCoder [
	owner := aGrammarCoder
]

{ #category : #private }
GtSmaCCCoder >> productionCompletionStrategy [
	^ owner productionCompletionStrategy
]

{ #category : #private }
GtSmaCCCoder >> referencesFilterAtCursor [
	self
		nodeForSelectionDo: [ :node :interval | 
			(node isKindOf: SmaCCClassProductionExpressionNode)
				ifTrue: [ (interval first >= node left startPosition
						and: [ interval last <= node right stopPosition ])
						ifTrue: [ ^ GtSmaCCNodeReferencesFilter name: node nodeName ] ].
			(node isKindOf: SmaCCSymbolNode)
				ifTrue: [ (node variableNameToken notNil
						and: [ self isInterval: interval inside: node variableNameToken ])
						ifTrue: [ ^ GtSmaCCVariableReferencesFilter
								name: node variableNameToken source ] ].
			((node isKindOf: SmaCCSymbolNode)
				or: [ (node isKindOf: SmaCCTokenRegexNode)
						or: [ (node isKindOf: SmaCCProductionRuleNode)
								or: [ node isKindOf: SmaCCTokenRuleNode ] ] ])
				ifTrue: [ (self isInterval: interval inside: node name)
						ifTrue: [ ^ GtSmaCCDefinitionReferencesFilter name: node name source ] ] ].
	^ nil
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> removeAttributeNamed: aSymbol [
	attributes isNil
		ifTrue: [ ^ self ].
	^ attributes removeKey: aSymbol ifAbsent: [  ]
]

{ #category : #actions }
GtSmaCCCoder >> renameItem: anElement [
	| token |
	token := self selectedToken.
	token isNil
		ifTrue: [ ^ self ].
	(token source first = $< and: [ token size > 2 ])
		ifTrue: [ self renameTokenNamed: token in: anElement ].
	token source first isLetter
		ifTrue: [ self renameProductionNamed: token in: anElement ]
]

{ #category : #'private-actions' }
GtSmaCCCoder >> renameProductionNamed: aSmaCCToken in: anElement [
	| coderIntervalMap |
	coderIntervalMap := self coderRenamePositionsForProduction: aSmaCCToken.
	self installRenameActionOn: anElement forCoders: coderIntervalMap
]

{ #category : #'private-actions' }
GtSmaCCCoder >> renameTokenNamed: aSmaCCToken in: anElement [
	| coderIntervalMap |
	coderIntervalMap := self coderRenamePositionsForToken: aSmaCCToken.
	self installRenameActionOn: anElement forCoders: coderIntervalMap
]

{ #category : #private }
GtSmaCCCoder >> selectedSourceInterval [
	self sourceEditor selection
		do: [ :each | ^ each from + 1 to: each to ].
	self sourceEditor cursors
		do: [ :each | ^ each position to: each position ].
	^ nil
]

{ #category : #private }
GtSmaCCCoder >> selectedToken [
	| token interval |
	interval := self selectedSourceInterval.
	interval isNil
		ifTrue: [ ^ nil ].
	self ast
		allNodesDo: [ :each |  ]
		andTokensDo: [ :each | 
			(each startPosition <= interval first
				and: [ each stopPosition >= interval last ])
				ifTrue: [ token := each ] ].
	^ token
]

{ #category : #private }
GtSmaCCCoder >> shortcuts [
	^ {(BlShortcut new
		combination: BlKeyCombination primaryN;
		repeatable: false;
		action: [ :editorElement | self browseReferences: editorElement ]).
	(BlShortcut new
		combination: BlKeyCombination primaryR;
		repeatable: false;
		action: [ :editorElement | self renameItem: editorElement ])}
]

{ #category : #accessing }
GtSmaCCCoder >> source [
	^ grammarItem source
]

{ #category : #'event handling' }
GtSmaCCCoder >> sourceChanged [
	| source |
	source := self sourceEditor text asString.
	grammarItem source = source
		ifTrue: [ ^ self ].
	grammarItem source: source.
	owner updateCompletions
]

{ #category : #editor }
GtSmaCCCoder >> sourceEditor [
	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #editor }
GtSmaCCCoder >> sourceText [
	| text |
	text := grammarItem source asRopedText.
	text attributes: self defaultTextAttributes.
	^ text
]

{ #category : #private }
GtSmaCCCoder >> styleSource [
	self sourceEditor styleText
]

{ #category : #private }
GtSmaCCCoder >> tokenCompletionStrategy [
	^ owner tokenCompletionStrategy
]

{ #category : #private }
GtSmaCCCoder >> updateCollapsedSource [
	| text |
	text := self collapsedText.
	text attributes: self defaultTextAttributes.
	self collapsedEditor text: text readonly
]
