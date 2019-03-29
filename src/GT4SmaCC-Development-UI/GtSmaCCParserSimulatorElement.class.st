Class {
	#name : #GtSmaCCParserSimulatorElement,
	#superclass : #BlElement,
	#instVars : [
		'simulator',
		'grammarCoder',
		'parseTreeElement'
	],
	#classVars : [
		'ErrorAttributes'
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
GtSmaCCParserSimulatorElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addChild:
			(BrLabel new
				text: simulator ruleName , ' input:';
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	self addChild: self testElement as: #testInput.
	self addChild: self parseTreeElement as: #parseTree
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> clearAttributesIn: editor [
	| text |
	text := editor text.
	text clearAttributes: [ :attr | attr == ErrorAttributes first ].
	^ editor text: text
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
		ifTrue: [ ^ anObject source ].
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
			parseTreeElement ]
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> simulateInput [
	| editor |
	editor := self testEditor.
	self clearAttributesIn: editor.
	simulator simulateOn: editor text asString
]

{ #category : #'initialize-release' }
GtSmaCCParserSimulatorElement >> simulator: aSimulator [
	simulator := aSimulator.
	simulator announcer weak
		subscribe: GtSmaCCParserSimulationAccept send: #accepted: to: self;
		subscribe: GtSmaCCParserSimulationError send: #failed: to: self;
		subscribe: GtSmaCCParserSimulationIncompleteInput
			send: #incomplete:
			to: self.
	grammarCoder := GtSmaCCGrammarCoder onGrammar: simulator grammar.
	self buildElement
]

{ #category : #private }
GtSmaCCParserSimulatorElement >> testEditor [
	^ (self childNamed: #testInput) editor
]

{ #category : #ui }
GtSmaCCParserSimulatorElement >> testElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorDeletedEvent do: [ :event | self simulateInput ];
		when: BrTextEditorInsertedEvent do: [ :event | self simulateInput ].
	editor
		text: ('' asRopedText attributes: GtSmaCCCoder defaultTextAttributes).
	element := BrEditorElement new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element margin: (BlInsets all: 5).
	element padding: (BlInsets all: 3).
	element editor: editor.
	^ element
]
