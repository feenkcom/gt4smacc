Class {
	#name : #GtSmaCCParserSimulatorElement,
	#superclass : #GtSmaCCSimulatorElement,
	#instVars : [
		'parseTreeElement'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'class initialization' }
GtSmaCCParserSimulatorElement class >> initialize [
	ErrorAttributes := {(BlTextUnderlineAttribute new
		color: BrGlamorousColors errorBorderColor;
		thickness: 3)}
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> accepted: anAcceptAnnouncement [
	self testEditor styleText.
	self displayResult: anAcceptAnnouncement results first
]

{ #category : #ui }
GtSmaCCParserSimulatorElement >> buildResultsElement [
	self addChild: self parseTreeElement as: #parseTree
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> childrenOf: anObject [
	^ (anObject isKindOf: SmaCCReducedItem)
		ifTrue: [ anObject items ]
		ifFalse: [ (anObject isKindOf: Association)
				ifTrue: [ anObject value ]
				ifFalse: [ #() ] ]
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> cursorMoved [
	| position |
	position := self inputCursorPosition.
	position = 0
		ifTrue: [ ^ self ].
	self parseTreeElement viewModel itemCount = 0
		ifTrue: [ ^ self ].
	(self
		selectNodeAt: position
		from: (self parseTreeElement viewModel itemAt: 1))
		ifNotNil: [ :node | 
			1 to: self parseTreeElement viewModel itemCount do: [ :i | 
				(self parseTreeElement viewModel itemAt: i) == node
					ifTrue: [ self parseTreeElement selectOne: i ] ] ]
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> displayError: stack token: aSmaCCToken [
	| root |
	root := aSmaCCToken isNil
		ifTrue: [ ('Incomplete' asRopedText foreground: Color yellow muchDarker)
				-> stack ]
		ifFalse: [ ('Error' asRopedText foreground: BrGlamorousColors errorBorderColor)
				-> (stack copyWith: aSmaCCToken) ].
	self parseTreeElement
		items: {root}
		children: [ :each | self childrenOf: each ].
	self expandRoot
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> displayResult: reducedItem [
	self parseTreeElement
		items: {reducedItem}
		children: [ :each | self childrenOf: each ].
	self expandRoot
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> expandRoot [
	(self parseTreeElement viewModel itemAt: 1) expand
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> failed: errorAnnouncement [
	| editor text |
	editor := self testEditor.
	text := editor text.
	text size >= errorAnnouncement index
		ifTrue: [ (text from: errorAnnouncement index to: text size)
				attributes: ErrorAttributes ].
	self
		displayError: errorAnnouncement stack
		token: errorAnnouncement token
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> highlightInputFrom: startPosition to: stopPosition [
	| editor text |
	editor := self testEditor.
	text := editor text.
	text size >= stopPosition
		ifFalse: [ ^ self ].
	(text from: startPosition to: stopPosition)
		attributes: AcceptAttributes.
	editor text: text
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> incomplete: incompleteAnnouncement [
	self testEditor styleText.
	self displayError: incompleteAnnouncement stack token: nil
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> labelFor: anObject [
	(anObject isKindOf: SmaCCReducedItem)
		ifTrue: [ ^ anObject rhs productionSymbol name ].
	(anObject isKindOf: SmaCCToken)
		ifTrue: [ anObject isSyntaxError
				ifTrue: [ ^ 'Scanner Error' asRopedText
						foreground: BrGlamorousColors errorBorderColor ].
			^ anObject source ].
	(anObject isKindOf: Association)
		ifTrue: [ ^ anObject key ].
	^ self error: 'Unknown object'
]

{ #category : #ui }
GtSmaCCParserSimulatorElement >> parseTreeElement [
	^ parseTreeElement
		ifNil: [ parseTreeElement := BrColumnedTree new.
			parseTreeElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			parseTreeElement items: #() children: [ :each |  ].
			parseTreeElement column
				stencil: [ :each | 
					BrColumnCellLabelStencil new
						text: (self labelFor: each) asRopedText glamorousRegularFontAndSize ].
			parseTreeElement
				when: BrSelectionChanged
				do:
					[ :anEvent | parseTreeElement selectedNodeDo: [ :aNode | self selected: aNode ] ].
			parseTreeElement ]
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> phlowSelection: aNode [
	| name value node |
	node := aNode.
	[ value := node value.
	name := nil.
	(value isKindOf: SmaCCReducedItem)
		ifTrue: [ name := value rhs productionSymbol name ].
	(value isKindOf: SmaCCToken)
		ifTrue: [ name := simulator symbolNameFor: value ids first ].
	name notNil
		ifTrue: [ (grammarCoder coderNamed: name)
				ifNotNil: [ :coder | 
					coder expanded: true.
					^ self parseTreeElement phlow selectObject: coder asElement ] ].
	node := node parent.
	node notNil ] whileTrue
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> selectNodeAt: anInteger from: treeNode [
	(self selectionIntervalFor: treeNode value)
		ifNotNil: [ :interval | 
			(interval first <= anInteger and: [ interval last >= anInteger ])
				ifTrue: [ treeNode expand.
					treeNode childrenNodes
						do:
							[ :each | (self selectNodeAt: anInteger from: each) ifNotNil: [ :node | ^ node ] ].
					^ treeNode ] ].
	^ nil
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> selected: aNode [
	self phlowSelection: aNode.
	self styleSelection: aNode
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> selectionIntervalFor: anObject [
	(anObject isKindOf: Association)
		ifTrue: [ ^ 1 to: self testEditor text size ].
	^ (anObject respondsTo: #sourceInterval)
		ifTrue: [ anObject sourceInterval ]
]

{ #category : #'initialize-release' }
GtSmaCCParserSimulatorElement >> setupSimulator [
	simulator weak
		when: GtSmaCCParserSimulationAccept send: #accepted: to: self;
		when: GtSmaCCParserSimulationError send: #failed: to: self;
		when: GtSmaCCParserSimulationIncompleteInput
			send: #incomplete:
			to: self.
	grammarCoder := GtSmaCCGrammarCoder onGrammar: simulator grammar.
	self buildElement
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> styleSelection: aNode [
	| value |
	self clearAttributesIn: self testEditor.
	value := aNode value.
	(value isKindOf: SmaCCToken)
		ifTrue:
			[ self highlightInputFrom: value startPosition to: value stopPosition ].
	(value isKindOf: SmaCCReducedItem)
		ifTrue: [ value sourceInterval
				ifNotNil:
					[ :interval | self highlightInputFrom: interval first to: interval last ] ]
]
