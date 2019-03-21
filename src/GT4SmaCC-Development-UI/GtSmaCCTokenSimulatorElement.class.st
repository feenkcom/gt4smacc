Class {
	#name : #GtSmaCCTokenSimulatorElement,
	#superclass : #BlElement,
	#instVars : [
		'simulator',
		'grammarCoder'
	],
	#classVars : [
		'AcceptAttributes',
		'ErrorAttributes'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'class initialization' }
GtSmaCCTokenSimulatorElement class >> initialize [
	ErrorAttributes := {(BlTextUnderlineAttribute new
		paint: BrGlamorousColors errorBorderColor;
		width: 3)}.
	AcceptAttributes := {(BlTextUnderlineAttribute new
		paint: BrGlamorousColors successBackgroundColor;
		width: 3;
		beNotOverwritableByStyler)}
]

{ #category : #'instance creation' }
GtSmaCCTokenSimulatorElement class >> onSimulator: aSimulator [
	^ self new
		simulator: aSimulator;
		yourself
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> add: aTokenRule to: aGroup [
	(aGroup includes: aTokenRule)
		ifTrue: [ ^ self ].
	aGroup add: aTokenRule.
	aTokenRule ast
		allNodesOfType: SmaCCTokenRegexNode
		do: [ :node | 
			(grammarCoder ruleNamed: node name source)
				ifNotNil: [ :rule | self add: rule to: aGroup ] ]
]

{ #category : #ui }
GtSmaCCTokenSimulatorElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addChild:
			(BrLabel new
				text: 'Input:';
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	self addChild: self testElement as: #testInput.
	self addChild: self listElement as: #list
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> clearAttributesIn: editor [
	| text |
	text := editor text.
	text
		clearAttributes:
			[ :attr | attr == AcceptAttributes first or: [ attr == ErrorAttributes first ] ].
	^ editor text: text
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> inputCursorPosition [
	self testEditor cursors do: [ :each | ^ each position ].
	^ 0
]

{ #category : #ui }
GtSmaCCTokenSimulatorElement >> listElement [
	| element group |
	group := GtSmaCCDefinitionGroupResult onCoder: grammarCoder.
	self add: simulator tokenRule to: group.
	element := group asElement.
	element group coders do: [ :each | each expanded: true ].
	(element childNamed: #filter) removeFromParent.
	^ element
]

{ #category : #accessing }
GtSmaCCTokenSimulatorElement >> simulator [
	^ simulator
]

{ #category : #'initialize-release' }
GtSmaCCTokenSimulatorElement >> simulator: aSimulator [
	simulator := aSimulator.
	simulator announcer weak
		subscribe: GtSmaCCSimulationError send: #styleError: to: self;
		subscribe: GtSmaCCSimulationAccept send: #styleAccept: to: self.
	grammarCoder := GtSmaCCGrammarCoder
		onGrammar: simulator tokenRule grammar.
	self buildElement
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> styleAccept: acceptAnnouncement [
	| group |
	self clearAttributesIn: self testEditor.
	self inputCursorPosition < acceptAnnouncement index
		ifTrue: [ ^ self ].
	group := (self childNamed: #list) group.
	group coders
		do: [ :each | self clearAttributesIn: each sourceEditor ].
	acceptAnnouncement nodes isEmpty
		ifTrue: [ ^ self ].
	acceptAnnouncement nodes
		do: [ :each | 
			| tokenRule start name coder text |
			tokenRule := each nodeOfType: SmaCCTokenRuleNode.
			start := tokenRule startPosition - 1.
			name := tokenRule name source.
			coder := group coderFor: (grammarCoder ruleNamed: name).
			coder notNil
				ifTrue: [ text := coder sourceEditor text.
					self inputCursorPosition = acceptAnnouncement index
						ifTrue: [ each
								testTokensDo: [ :token | 
									(text from: token startPosition - start to: token stopPosition - start)
										attributes: AcceptAttributes ] ].
					coder sourceEditor text: text ] ]
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> styleError: errorAnnouncement [
	| editor |
	editor := self testEditor.
	self clearAttributesIn: editor.
	editor
		styleTextAndAfterDo: [ | text |
			text := editor text.
			text size >= errorAnnouncement index
				ifTrue: [ (text from: errorAnnouncement index to: text size)
						attributes: ErrorAttributes ] ]
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> testEditor [
	^ (self childNamed: #testInput) editor
]

{ #category : #ui }
GtSmaCCTokenSimulatorElement >> testElement [
	| element editor |
	editor := BrTextEditor new.
	editor
		when: BrTextEditorDeletedEvent
			do: [ :event | simulator simulateOn: editor text asString ];
		when: BrTextEditorInsertedEvent
			do: [ :event | simulator simulateOn: editor text asString ];
		when: BrTextEditorCursorMovedEvent
			do: [ :event | simulator simulateOn: editor text asString ].
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
