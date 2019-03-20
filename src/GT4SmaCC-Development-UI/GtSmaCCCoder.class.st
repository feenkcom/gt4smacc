Class {
	#name : #GtSmaCCCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'owner',
		'expanded',
		'collapsedEditor',
		'sourceEditor',
		'originalSource',
		'attributes',
		'originalAST',
		'ast'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCCoder class >> on: aNode in: aGrammarCoder [
	^ self new
		owner: aGrammarCoder;
		originalAST: aNode;
		yourself
]

{ #category : #actions }
GtSmaCCCoder >> actions [
	^ {(GtCoderAction new
		title: 'Inspect' translated;
		icon: BrGlamorousIcons playinspect;
		action: [ :button | self inspectFrom: button ];
		yourself)}
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
	^ ast ifNil: [ originalAST ]
]

{ #category : #private }
GtSmaCCCoder >> astFor: aString [
	^ SmaCCDefinitionParser
		parseWithErrors: aString
		startingAt: self parserStartingState
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
				object: (filter applyInScope: owner coders);
				sourceElement: anElement)
]

{ #category : #editor }
GtSmaCCCoder >> collapsedEditor [
	collapsedEditor isNil
		ifTrue: [ collapsedEditor := self newCollapsedEditor.
			self updateCollapsedSource ].
	^ collapsedEditor
]

{ #category : #accessing }
GtSmaCCCoder >> completionStrategy [
	^ nil
]

{ #category : #editor }
GtSmaCCCoder >> defaultTextAttributes [
	^ {(BlFontFamilyAttribute named: 'Source Code Pro')
		beNotOverwritableByStyler.
	BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 12) beNotOverwritableByStyler}
]

{ #category : #accessing }
GtSmaCCCoder >> definitionName [
	self subclassResponsibility
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

{ #category : #actions }
GtSmaCCCoder >> inspectFrom: anElement [
	anElement phlow spawnObject: self
]

{ #category : #testing }
GtSmaCCCoder >> isModified [
	^ self source ~= originalSource
]

{ #category : #testing }
GtSmaCCCoder >> isProductionRuleCoder [
	^ false
]

{ #category : #testing }
GtSmaCCCoder >> isTokenRuleCoder [
	^ false
]

{ #category : #testing }
GtSmaCCCoder >> isValid [
	^ [ SmaCCDefinitionParser
		parse: self source
		startingAt: self parserStartingState.
	true ]
		on: SmaCCParserError
		do: [ :ex | ex return: false ]
]

{ #category : #editor }
GtSmaCCCoder >> newCollapsedEditor [
	^ BrTextEditor new
]

{ #category : #editor }
GtSmaCCCoder >> newSourceEditor [
	| text |
	text := originalSource asRopedText.
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

{ #category : #'initialize-release' }
GtSmaCCCoder >> originalAST: aNode [
	originalAST := aNode.
	originalSource := aNode source.
	ast := self astFor: originalSource
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
GtSmaCCCoder >> parserStartingState [
	^ self subclassResponsibility
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
	^ sourceEditor isNil
		ifTrue: [ originalSource ]
		ifFalse: [ sourceEditor text asString ]
]

{ #category : #'event handling' }
GtSmaCCCoder >> sourceChanged [
	ast := self astFor: self source.
	self updateCollapsedSource
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

{ #category : #editor }
GtSmaCCCoder >> styledName [
	^ self definitionName asRopedText
]

{ #category : #private }
GtSmaCCCoder >> updateCollapsedSource [
	self styleSource
]

{ #category : #source }
GtSmaCCCoder >> updateSource: aSmaCCString [
	self isModified
		ifFalse: [ ^ self ].
	originalAST isNil
		ifTrue: [ aSmaCCString append: String cr , self source ]
		ifFalse: [ aSmaCCString
				replaceFrom: originalAST startPosition
				to: originalAST stopPosition
				with: self source ]
]
