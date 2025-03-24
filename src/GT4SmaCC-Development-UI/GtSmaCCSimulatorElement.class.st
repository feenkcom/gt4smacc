Class {
	#name : #GtSmaCCSimulatorElement,
	#superclass : #BrVerticalPane,
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
GtSmaCCSimulatorElement class >> initialize [
	ErrorAttributes := {(BlTextUnderlineAttribute new
		color: BrGlamorousColors errorBorderColor;
		thickness: 3)}.
	AcceptAttributes := {(BlTextUnderlineAttribute new
		color: BrGlamorousColors successBackgroundColor;
		thickness: 3;
		beNotOverwritableByStyler)}
]

{ #category : #'instance creation' }
GtSmaCCSimulatorElement class >> onSimulator: aSimulator [
	^ self new
		simulator: aSimulator;
		yourself
]

{ #category : #ui }
GtSmaCCSimulatorElement >> buildElement [
	self buildInputElement.
	self buildResultsElement
]

{ #category : #ui }
GtSmaCCSimulatorElement >> buildInputElement [
	self matchParent.
	self
		addChild: (BrLabel new
				text: simulator ruleName , ' input:';
				aptitude: BrGlamorousLabelAptitude new;
				padding: (BlInsets all: 5);
				hFitContent;
				yourself).
	self addChild: self testElement as: #testInput
]

{ #category : #ui }
GtSmaCCSimulatorElement >> buildResultsElement [
	self subclassResponsibility
]

{ #category : #private }
GtSmaCCSimulatorElement >> clearAttributesIn: editor [
	editor text
		clearAttributes:
			[ :attr | attr == AcceptAttributes first or: [ attr == ErrorAttributes first ] ]
]

{ #category : #'event handling' }
GtSmaCCSimulatorElement >> cursorMoved [
	
]

{ #category : #private }
GtSmaCCSimulatorElement >> inputCursorPosition [
	self testEditor cursors do: [ :each | ^ each position ].
	^ 0
]

{ #category : #'initialize-release' }
GtSmaCCSimulatorElement >> setupSimulator [
	self subclassResponsibility
]

{ #category : #'event handling' }
GtSmaCCSimulatorElement >> simulateInput [
	| editor |
	editor := self testEditor.
	self clearAttributesIn: editor.
	simulator simulateOn: editor text asString
]

{ #category : #accessing }
GtSmaCCSimulatorElement >> simulator [
	^ simulator
]

{ #category : #'initialize-release' }
GtSmaCCSimulatorElement >> simulator: aSimulator [
	simulator := aSimulator.
	self setupSimulator
]

{ #category : #private }
GtSmaCCSimulatorElement >> testEditor [
	^ (self childNamed: #testInput) editor
]

{ #category : #ui }
GtSmaCCSimulatorElement >> testElement [
	| element editor |
	editor := BrTextEditorModel new.
	editor
		when: BrTextEditorDeletedEvent do: [ :event | self simulateInput ];
		when: BrTextEditorInsertedEvent do: [ :event | self simulateInput ];
		when: BrTextEditorCursorMovedEvent do: [ :event | self cursorMoved ].
	editor text: ('' asRopedText attributes: GtSmaCCCoder defaultTextAttributes).
	element := BrEditorElement new.
	element
		addAptitude: (BrGlamorousWithExplicitTooltipAptitude text: 'Source To Simulate on').
	element
		constraintsDo: [ :c | 
			c maxHeight: 350.
			c horizontal matchParent.
			c vertical fitContent ].
	element border: (BlBorder paint: self theme editor borderColor width: 1).
	element margin: (BlInsets all: 5).
	element padding: (BlInsets all: 3).
	element editor: editor.
	^ element
]
