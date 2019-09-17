Class {
	#name : #GtSmaCCGrammarElement,
	#superclass : #BlElement,
	#instVars : [
		'grammar',
		'completionStrategy'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCGrammarElement class >> onGrammar: aGrammar [
	^ self new
		grammar: aGrammar;
		yourself
]

{ #category : #ui }
GtSmaCCGrammarElement >> actionBar [
	^ BrToolbar new
		look: BrToolbarLook new;
		padding: (BlInsets all: 5);
		layout:
			(BlGridLayout horizontal
				rowCount: 1;
				cellSpacing: 3);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addItem:
			(BrButton new
				beSmall;
				look: BrGlamorousButtonWithIconLook;
				label: 'Save';
				icon: BrGlamorousIcons accept asElement;
				action: [ :element | self save ])
]

{ #category : #ui }
GtSmaCCGrammarElement >> buildInterface [
	self layout: BlLinearLayout vertical.
	self padding: (BlInsets all: 5).
	self
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	self addChild: self sourceEditorElement as: #source.
	self addChild: self actionBar
]

{ #category : #private }
GtSmaCCGrammarElement >> displayError: aString at: anIndex [
	| index |
	index := (anIndex - 1 max: 1) min: self sourceEditor text size.
	(self sourceEditor text from: index to: index)
		attributes: {(GtSourceCoderErrorAttribute for: aString)}.
	self sourceEditor
		invalidate: index to: index;
		update: index to: index.
	self sourceEditor moveCursorTo: index
]

{ #category : #accessing }
GtSmaCCGrammarElement >> grammar [
	^ grammar
]

{ #category : #accessing }
GtSmaCCGrammarElement >> grammar: aGrammar [
	grammar := aGrammar.
	self updateEditor
]

{ #category : #'initialize-release' }
GtSmaCCGrammarElement >> initialize [
	super initialize.
	self buildInterface
]

{ #category : #actions }
GtSmaCCGrammarElement >> save [
	[ SmaCCGrammarCompiler new
		buildDefinition: self source;
		compileInto: grammar scannerClassName
			andParser: grammar parserClassName ]
		on: SmaCCParserError
		do: [ :ex | self displayError: ex description at: ex tag position ]
]

{ #category : #private }
GtSmaCCGrammarElement >> source [
	^ self sourceEditor text asString
]

{ #category : #private }
GtSmaCCGrammarElement >> sourceEditor [
	^ self sourceElement editor
]

{ #category : #ui }
GtSmaCCGrammarElement >> sourceEditorElement [
	| completionController element |
	element := BrEditor new.
	element background: Color white.
	element padding: (BlInsets all: 10).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element look: BrGlamorousCodeEditorLook new.
	completionStrategy := GtWeightedStringsCompletionStrategy new.
	completionController := GtCompletionController
		on: element
		strategy: completionStrategy.
	completionController closeOnEmptyCompletion: false.
	completionController install.
	^ element
]

{ #category : #private }
GtSmaCCGrammarElement >> sourceElement [
	^ self childNamed: #source
]

{ #category : #private }
GtSmaCCGrammarElement >> updateEditor [
	| styler text |
	styler := GtSmaCCGrammarStyler
		for:
			([ grammar scannerClass ]
				on: Error
				do: [ :ex | ex return: SmaCCScanner ]).
	styler
		when: BlTextStyledEvent
		do: [ :event | completionStrategy completions: styler completions ].
	text := grammar source asRopedText.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	self sourceEditor
		text: text;
		styler: styler
]
