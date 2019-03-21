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

{ #category : #accessing }
GtSmaCCCoder class >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro')
		beNotOverwritableByStyler.
	BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}
]

{ #category : #'instance creation' }
GtSmaCCCoder class >> on: aGrammarItem in: aGrammarCoder [
	aGrammarItem isDirective
		ifTrue: [ ^ nil ].
	^ self new
		owner: aGrammarCoder;
		grammarItem: aGrammarItem;
		yourself
]

{ #category : #actions }
GtSmaCCCoder >> actions [
	^ grammarItem isTokenRule
		ifTrue: [ {(GtCoderAction new
				title: 'Simulate' translated;
				icon: BrGlamorousIcons debug;
				action: [ :button | self viewSimulator: button ];
				yourself)} ]
		ifFalse: [ #() ]
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

{ #category : #actions }
GtSmaCCCoder >> browseReferences: anElement [
	| filter |
	filter := self referencesFilterAtCursor.
	filter isNil
		ifTrue: [ ^ self ].
	anElement
		fireEvent:
			(GtPhlowObjectToSpawn new
				object: (filter applyInScope: owner group) asElement;
				sourceElement: anElement)
]

{ #category : #editor }
GtSmaCCCoder >> collapsedEditor [
	collapsedEditor isNil
		ifTrue: [ collapsedEditor := self newCollapsedEditor.
			self styleSource ].
	^ collapsedEditor
]

{ #category : #accessing }
GtSmaCCCoder >> completionStrategy [
	grammarItem isProductionRule
		ifTrue: [ ^ owner productionCompletionStrategy ].
	grammarItem isTokenRule
		ifTrue: [ ^ owner tokenCompletionStrategy ].
	^ nil
]

{ #category : #editor }
GtSmaCCCoder >> defaultTextAttributes [
	^ self class defaultTextAttributes
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
GtSmaCCCoder >> grammarItem [
	^ grammarItem
]

{ #category : #accessing }
GtSmaCCCoder >> grammarItem: aGrammarItem [
	grammarItem := aGrammarItem
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

{ #category : #testing }
GtSmaCCCoder >> isModified [
	^ grammarItem isModified
]

{ #category : #testing }
GtSmaCCCoder >> isValid [
	^ grammarItem isValid
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
	| text |
	text := grammarItem source asRopedText.
	text attributes: self defaultTextAttributes.
	^ BrTextEditor new
		styler: self newStyler;
		text: text;
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ];
		yourself
]

{ #category : #editor }
GtSmaCCCoder >> newStyler [
	^ GtSmaCCStyler new
		coder: self;
		yourself
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
			(each startPosition <= interval first
				and: [ each stopPosition >= interval last ])
				ifTrue: [ node := each ] ].
	node notNil
		ifTrue: [ aBlock cull: node cull: interval ]
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
GtSmaCCCoder >> referencesFilterAtCursor [
	self
		nodeForSelectionDo: [ :node :interval | 
			((node isKindOf: SmaCCSymbolNode)
				or: [ (node isKindOf: SmaCCTokenRegexNode)
						or: [ (node isKindOf: SmaCCProductionRuleNode)
								or: [ node isKindOf: SmaCCTokenRuleNode ] ] ])
				ifTrue: [ (interval first >= node name startPosition
						and: [ interval last <= node name stopPosition ])
						ifTrue: [ ^ self referencesFilterFor: node name source ] ] ].
	^ nil
]

{ #category : #private }
GtSmaCCCoder >> referencesFilterFor: aString [
	^ GtSmaCCDefinitionReferencesFilter name: aString
]

{ #category : #'accessing-attributes' }
GtSmaCCCoder >> removeAttributeNamed: aSymbol [
	attributes isNil
		ifTrue: [ ^ self ].
	^ attributes removeKey: aSymbol ifAbsent: [  ]
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
GtSmaCCCoder >> shortcuts [
	^ {(BlShortcut new
		combination: BlKeyCombination primaryN;
		action: [ :editorElement | self browseReferences: editorElement ])}
]

{ #category : #accessing }
GtSmaCCCoder >> source [
	^ grammarItem source
]

{ #category : #'event handling' }
GtSmaCCCoder >> sourceChanged [
	grammarItem source: self sourceEditor text asString.
	self styleSource.
	owner updateCompletions
]

{ #category : #editor }
GtSmaCCCoder >> sourceEditor [
	^ sourceEditor ifNil: [ sourceEditor := self newSourceEditor ]
]

{ #category : #private }
GtSmaCCCoder >> styleSource [
	[ | name |
	name := self ast name.
	self sourceEditor
		styleTextAndAfterDo: [ self collapsedEditor
				text:
					(self sourceEditor text
						copyFrom: name startPosition
						to: name stopPosition) readonly ] ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #private }
GtSmaCCCoder >> updateCollapsedSource [
	self styleSource
]

{ #category : #actions }
GtSmaCCCoder >> viewSimulator: anElement [
	| simulator ui |
	simulator := GtSmaCCTokenSimulator on: grammarItem.
	ui := GtSmaCCTokenSimulatorElement onSimulator: simulator.
	anElement phlow spawnObject: ui
]
