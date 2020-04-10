Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> debug: aString from: anElement [
	| process context debuggingSession |
	context := [ self parse: aString ] asContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	debuggingSession := process
		newDebugSessionNamed: 'Debug parse'
		startedAt: process suspendedContext.
	[ SmaCCParserDebugSession handlesContext: debuggingSession context ]
		whileFalse: [ debuggingSession stepInto ].
	process debug
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtAnnotationsFor: aView context: aDictionary [
	<gtClassView>
	| coder |
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	coder := aDictionary
		at: #coder
		ifAbsentPut: [ GtSmaCCGrammarCoder onParser: self ].
	^ aView explicit
		title: 'Annotations';
		priority: 2;
		stencil: [ coder asVariableElement ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtGrammarFor: aView [
	<gtView>
	^ self gtGrammarFor: aView context: Dictionary new
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtGrammarFor: aView context: aDictionary [
	<gtClassView>
	| coder |
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	coder := aDictionary
		at: #coder
		ifAbsentPut: [ GtSmaCCGrammarCoder onParser: self ].
	^ aView explicit
		title: 'Grammar';
		priority: 1;
		stencil: [ coder asElement ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtSourceFor: aView [
	<gtView>
	<gtClassView>
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Source';
		priority: 6;
		stencil: [ GtSmaCCGrammarElement onGrammar: (GtSmaCCGrammar onParser: self) ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtTestElement [
	| element editor actionBar editorElement text |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets all: 5).
	element
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ].
	editorElement := BrEditor new.
	editorElement padding: (BlInsets all: 2).
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editor := BrTextEditor new.
	text := '' asRopedText.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	editor text: text.
	self gtStyler ifNotNil: [ :styler | editor styler: styler ].
	editorElement editor: editor.
	actionBar := BrToolbar new
		look: BrGlamorousToolbarLook new;
		addItem:
			(BrButton new
				beSmall;
				look: BrGlamorousButtonWithIconLook;
				label: 'Inspect';
				icon: BrGlamorousVectorIcons inspect;
				action: [ :button | 
					[ button phlow spawnObject: (self parse: editor text asString) ]
						on: SmaCCParserError
						do: [ :ex | ex gtDisplayErrorIn: editor ] ]);
		addItem:
			(BrButton new
				beSmall;
				look: BrGlamorousButtonWithIconLook;
				label: 'Debug';
				icon: BrGlamorousVectorIcons debug;
				action: [ :button | self debug: editor text asString from: button ]).
	element addChild: editorElement.
	element addChild: actionBar.
	^ element
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtTestFor: aView [
	<gtView>
	<gtClassView>
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Test';
		priority: 7;
		stencil: [ self gtTestElement ]
]
