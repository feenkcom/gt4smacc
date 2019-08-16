Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> buildSmaCCGrammarSourceTabIn: tabGroup for: classCoder [
	<gtClassView: 6>
	self definitionString isEmpty
		ifTrue: [ ^ self ].
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Source';
				stencil: [ GtSmaCCGrammarElement onGrammar: (GtSmaCCGrammar onParser: self) ])
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> buildSmaCCGrammarTabIn: tabGroup for: classCoder [
	<gtClassView: 5>
	self definitionString isEmpty
		ifTrue: [ ^ self ].
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Grammar';
				stencil: [ (GtSmaCCGrammarCoder onParser: self) asElement ])
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> buildTestTabIn: tabGroup for: classCoder [
	<gtClassView: 7>
	self definitionString isEmpty
		ifTrue: [ ^ self ].
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Test';
				stencil: [ self gtTestElement ])
]

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
SmaCCParser class >> gtCoderFor: aView [
	<gtView>
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Grammar';
		priority: 1;
		stencil: [ (GtSmaCCGrammarCoder onParser: self) asElement ]
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
		look: BrToolbarLook new;
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
				label: 'Inspect';
				icon: BrGlamorousIcons inspect asElement;
				action: [ :button | 
					[ button phlow spawnObject: (self parse: editor text asString) ]
						on: SmaCCParserError
						do: [ :ex | ex gtDisplayErrorIn: editor ] ]);
		addItem:
			(BrButton new
				beSmall;
				look: BrGlamorousButtonWithIconLook;
				label: 'Debug';
				icon: BrGlamorousIcons debug asElement;
				action: [ :button | self debug: editor text asString from: button ]).
	element addChild: editorElement.
	element addChild: actionBar.
	^ element
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtTestFor: aView [
	<gtView>
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Test';
		priority: 1;
		stencil: [ self gtTestElement ]
]
