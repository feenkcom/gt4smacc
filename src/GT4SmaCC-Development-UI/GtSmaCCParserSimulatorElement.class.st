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
		paint: BrGlamorousColors errorBorderColor;
		width: 3)}
]

{ #category : #'instance creation' }
GtSmaCCParserSimulatorElement class >> onSimulator: aSimulator [
	^ self new
		simulator: aSimulator;
		yourself
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
GtSmaCCParserSimulatorElement >> displayError: stack token: aSmaCCToken [
	| root |
	root := aSmaCCToken isNil
		ifTrue: [ ('Incomplete' asRopedText foreground: Color yellow muchDarker)
				-> stack ]
		ifFalse: [ ('Error' asRopedText foreground: BrGlamorousColors errorBorderColor)
				-> (stack copyWith: aSmaCCToken) ].
	self parseTreeElement
		items: {root}
		children: [ :each | 
			(each isKindOf: SmaCCReducedItem)
				ifTrue: [ each items ]
				ifFalse: [ (each isKindOf: Association)
						ifTrue: [ each value ]
						ifFalse: [ #() ] ] ].
	self expandRoot
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> displayResult: reducedItem [
	self parseTreeElement
		items: {reducedItem}
		children: [ :each | 
			(each isKindOf: SmaCCReducedItem)
				ifTrue: [ each items ]
				ifFalse: [ #() ] ].
	self expandRoot
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> expandRoot [
	(self parseTreeElement viewModel itemAt: 1) expand
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> failed: errorAnnouncement [
	| editor |
	editor := self testEditor.
	editor
		styleTextAndAfterDo: [ | text |
			text := editor text.
			text size >= errorAnnouncement index
				ifTrue: [ (text from: errorAnnouncement index to: text size)
						attributes: ErrorAttributes ] ].
	self
		displayError: errorAnnouncement stack
		token: errorAnnouncement token
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
						text: (self labelFor: each value) asRopedText glamorousRegularFontAndSize ].
			parseTreeElement
				when: BrSelectionChanged
				do:
					[ :anEvent | parseTreeElement selectedNodeDo: [ :aNode | self selected: aNode ] ].
			parseTreeElement ]
]

{ #category : #'event handling' }
GtSmaCCParserSimulatorElement >> selected: aNode [
	| value name node |
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

{ #category : #'initialize-release' }
GtSmaCCParserSimulatorElement >> setupSimulator [
	simulator announcer weak
		subscribe: GtSmaCCParserSimulationAccept send: #accepted: to: self;
		subscribe: GtSmaCCParserSimulationError send: #failed: to: self;
		subscribe: GtSmaCCParserSimulationIncompleteInput
			send: #incomplete:
			to: self.
	grammarCoder := GtSmaCCGrammarCoder onGrammar: simulator grammar.
	self buildElement
]
