Class {
	#name : #GtSmaCCDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'scannerPropertiesList',
		'parserStackList',
		'stateActionsList',
		'sourceEditor',
		'parserTab',
		'scannerTab',
		'contextTab',
		'contextElement',
		'glrLabel'
	],
	#classInstVars : [
		'availableAutomatically'
	],
	#category : #'GT4SmaCC-Debugger'
}

{ #category : #accessing }
GtSmaCCDebuggerElement class >> availableAutomatically [
	^ availableAutomatically ifNil: [ false ]
]

{ #category : #accessing }
GtSmaCCDebuggerElement class >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #accessing }
GtSmaCCDebuggerElement class >> defaultTitle [
	^ 'SmaCCParser'
]

{ #category : #testing }
GtSmaCCDebuggerElement class >> handlesContext: aContext [
	^ SmaCCParserDebugSession handlesContext: aContext
]

{ #category : #'class initialization' }
GtSmaCCDebuggerElement class >> initialize [
	self register
]

{ #category : #'tools registry' }
GtSmaCCDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 900.
]

{ #category : #accessing }
GtSmaCCDebuggerElement class >> sessionClass [
	^ SmaCCParserDebugSession
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> acceptAttributes [
	^ {(BlTextHighlightAttribute paint: BrGlamorousColors debuggerTextHighlightColor)}
]

{ #category : #callbacks }
GtSmaCCDebuggerElement >> actOnDebugSessionChanged [
	self buildUI
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildDetails [
	| element |
	element := (BrVerticalPane new)
		matchParent;
		padding: (BlInsets all: 10).
	element addChild: self buildDetailsInspector as: #tabs.
	element addChild: self buildSource as: #source.
	^ element
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildDetailsInspector [
	^ BrTabGroup new
		aptitude: BrGlamorousTabGroupAptitude new;
		addTab:
			(parserTab := BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Parser';
				stencil: [ self buildParserElement ]);
		addTab:
			(scannerTab := BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Scanner';
				stencil: [ self buildScannerElement ])
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildGLRStates [
	^ glrLabel := BrLabel new
		aptitude: BrGlamorousLabelAptitude new;
		padding: (BlInsets all: 5);
		text: self glrStateText;
		hMatchParent;
		yourself
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserActions [
	stateActionsList := BrColumnedList new.
	stateActionsList 
		margin: (BlInsets all: 10); 
		addAptitude: BrShadowAptitude;
		background: Color white;
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new cellSpacing: 10).
	stateActionsList column
		title: 'Symbol';
		stencil: [ :each | 
			| text |
			text := each first asRopedText.
			text
				attributes:
					(each third
						ifTrue: [ {(BlTextForegroundAttribute paint: Color black).
							BlFontWeightAttribute bold} ]
						ifFalse: [ {(BlTextForegroundAttribute paint: Color red)} ]).
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: text;
				margin: (BlInsets top: 5 bottom: 5)].
	stateActionsList column
		title: 'Action';
		stencil: [ :each | 
			| text |
			text := each second asRopedText.
			text
				attributes:
					(each third
						ifTrue: [ {(BlTextForegroundAttribute paint: Color black).
							BlFontWeightAttribute bold} ]
						ifFalse: [ {(BlTextForegroundAttribute paint: Color red)} ]).
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: text;
				margin: (BlInsets top: 5 bottom: 5) ].
	^ stateActionsList
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserElement [
	| element |
	element := BrHorizontalPane new.
	element matchParent.
	element addChild: self buildParserStack as: #parserStack.
	element addChild: self buildParserActions as: #parserActions.
	self enqueueTask: [ self updateContents ] asBlTask.
	(self session parser isKindOf: SmaCCGLRParser) ifFalse: [ ^ element ].
	^ BrVerticalPane new
		matchParent;
		addChild: element;
		addChild: self buildGLRStates;
		yourself
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserStack [
	parserStackList := BrColumnedList new.
	parserStackList
		margin: (BlInsets all: 10);
		addAptitude: BrShadowAptitude;
		background: Color white;
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new cellSpacing: 10).
	parserStackList
		addEventHandler: (GtPhlowListToSelectHandler new transformation: [ :each | each first = '' ifFalse: [ each last ] ]).
	parserStackList
		when: BrSelectionChanged
		do: [ :event | event selectedDo: [ :each | self selectedStackItem: (parserStackList items at: each first) last ] ].
	(parserStackList column)
		title: 'Symbol';
		stencil:
				[ :each | 
					(BrLabel new)
						aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
						text: (each first ifNil: [ '' ]);
						margin: (BlInsets top: 5 bottom: 5) ].
	(parserStackList column)
		title: 'Value';
		stencil:
				[ :each | 
					(BrLabel new)
						aptitude: BrGlamorousLabelAptitude new;
						text: each last displayString;
						margin: (BlInsets top: 5 bottom: 5) ].
	^ parserStackList
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserToolbarActions [
	| buttons |
	buttons := self debuggerActions
			collect: [ :aDebuggingAction | 
				| actionButton |
				actionButton := BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: aDebuggingAction name;
						action: [ aDebuggingAction execute.
							self updateContents ].
				aDebuggingAction icon
					ifNotNil: [ :anIcon | actionButton icon: aDebuggingAction icon asElement ].
				actionButton ].
	^ buttons
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildScannerElement [
	| element |
	element := (BrHorizontalPane new)
		matchParent;
		padding: (BlInsets all: 10).
	element addChild: self buildScannerProperties as: #scannerProperties.
	self updateContents.
	^ element
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildScannerProperties [
	scannerPropertiesList := BrColumnedList new.
	scannerPropertiesList column
		title: 'Name';
		stencil: [ :each | 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: each first;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	scannerPropertiesList column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				text: each last displayString;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	^ scannerPropertiesList
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildSource [
	| editorElement text |
	text := self session inputText asRopedText.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	editorElement := BrEditor new.
	editorElement
		matchParent;
		margin: (BlInsets all: 10);
		addAptitude: BrShadowAptitude;
		background: Color white;
		padding: (BlInsets all: 10).
	sourceEditor := editorElement editor.
	sourceEditor text: text.
	^ editorElement
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildTabGroupForElement: anElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: [ BrValuableStencil from: anElement ];
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		toolbarStencil: [ | aToolbar |
			aToolbar := BrToolbar new.
			aToolbar aptitude: BrGlamorousToolbarAptitude new.
			self buildParserToolbarActions
				do: [ :anAction | aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude:
			(BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: self theme status errorBackgroundColor;
				yourself).
	^ tabGroup
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildUI [
	| detailsElement |
	self removeChildren.
	detailsElement := self buildDetails.
	self addChild: (self buildTabGroupForElement: detailsElement)
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> clearAttributes [
	sourceEditor isNil
		ifTrue: [ ^ self ].
	sourceEditor text
		clearAttributes: [ :attr | attr class = BlTextHighlightAttribute ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> contextCoder [
	contextElement isNil ifTrue: [ ^ nil ].
	^ ((contextElement childNamed: #coderElement) childAt: 1) coderViewModel
]

{ #category : #accessing }
GtSmaCCDebuggerElement >> currentContext [
	^ self interruptedContext
]

{ #category : #accessing }
GtSmaCCDebuggerElement >> currentInputSelectionInterval [
	sourceEditor isNil
		ifTrue: [ ^ 1 to: 0 ].
	sourceEditor selection
		do: [ :each | ^ each interval first + 1 to: each interval last ].
	sourceEditor cursors
		do: [ :each | ^ each position + 1 to: each position + 1 ].
	^ 1 to: 0
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> debuggerActions [
	^ {SmaCCParserStepThroughAction.
		SmaCCParserStepToReduceAction.
		SmaCCParserNextTokenAction.
		SmaCCStepToNextCharacterAction.
		SmaCCStepToCursorAction} collect: [ :each | each forDebugger: self ]
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> glrStateText [
	| text index states |
	states := self session glrParserStates.
	index := states
		identityIndexOf: self session parser currentGLRState
		ifAbsent: [ 1 ].
	text := ('GLR State: ' , index printString , ' of '
		, states size printString) asRopedText.
	text bold.
	^ text
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> highlightFrom: start to: end with: attributes [
	(sourceEditor isNil or: [ end < start ])
		ifTrue: [ ^ self ].
	(sourceEditor text from: start to: end) attributes: attributes
]

{ #category : #'initialize-release' }
GtSmaCCDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> moveCursor [
	sourceEditor isNil
		ifTrue: [ ^ self ].
	sourceEditor moveCursorTo: self session scanner position
]

{ #category : #private }
GtSmaCCDebuggerElement >> parserDebuggingActionsPragmas [
	^ #(gtSmaCCDebuggingParserAction)
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> removeContext [
	| tab |
	contextTab isNil
		ifTrue: [ ^ self ].
	tab := contextTab.
	contextTab := nil.
	contextElement := nil.
	self
		enqueueTask:
			(BlTaskAction new
				action: [ self tabs removeTab: tab.
					self session isScanning
						ifTrue: [ scannerTab select ]
						ifFalse: [ parserTab select ] ])
]

{ #category : #private }
GtSmaCCDebuggerElement >> scannerDebuggingActionsPragmas [
	^ #(gtSmaCCDebuggingInputAction gtSmaCCDebuggingScannerAction)
]

{ #category : #private }
GtSmaCCDebuggerElement >> scrollTo: anInteger [
	self
		childNamed: #source
		ifFound: [ :element | 
			element
				scrollToPosition: (sourceEditor text asString lineNumberCorrespondingToIndex: anInteger) ]
		ifNone: [  ]
]

{ #category : #private }
GtSmaCCDebuggerElement >> selectSourceFor: anObject [
	| interval |
	sourceEditor isNil
		ifTrue: [ ^ self ].
	self clearAttributes.
	interval := self session tokenIntervalFor: anObject.
	interval isNil
		ifTrue: [ ^ self ].
	self
		highlightFrom: interval first
		to: interval last
		with: self acceptAttributes.
	self scrollTo: interval first
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> selectedStackItem: value [
	value = '' ifTrue: [ ^ self ].
	self selectSourceFor: value
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> showContext [
	(contextElement notNil
		and: [ self contextCoder context ~~ self session context ])
		ifTrue: [ ^ self updateContextCoderElement ].
	contextTab isNil
		ifFalse: [ ^ self updateContextCoderSelection ].
	self tabs
		addTab:
			((contextTab := BrTab new)
				aptitude: BrGlamorousTabAptitude new;
				label: 'Context';
				stencil: [ contextElement := BlElement new.
					contextElement
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical matchParent ].
					self updateContextCoderElement.
					contextElement ])
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> tabs [
	^ self childNamed: #tabs
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateContents [
	self updateParserStack.
	self updateParserStates.
	self updateGLRStates.
	self updateScannerProperties.
	self clearAttributes.
	self session isScanning
		ifTrue: [ self updateScanner ]
		ifFalse: [ self updateParser ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateContextCoderElement [
	| coder |
	contextElement isNil
		ifTrue: [ ^ self ].
	contextElement
		childNamed: #coderElement
		ifFound: [ :element | contextElement removeChild: element ]
		ifNone: [  ].
	coder := GtPharoMethodContextCoder
		forContext: self session context
		session: self session.
	coder announcer
		when: GtCoderRefreshStackAnnouncement
		send: #updateContents
		to: self.
	contextElement
		addChild: coder asElement asScrollableElement
		as: #coderElement
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateContextCoderSelection [
	self contextCoder ifNotNil: [ :coder | coder updateProgramCounterRange ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateGLRStates [
	glrLabel isNil
		ifTrue: [ ^ self ].
	glrLabel text: self glrStateText
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateParser [
	(scannerTab notNil and: [ scannerTab viewModel isSelected ])
		ifTrue: [ self enqueueTask: (BlTaskAction new action: [ parserTab select ]) ].
	self session isInsideReductionAction
		ifTrue: [ self showContext ]
		ifFalse: [ self removeContext ].
	parserStackList selectedIndices
		do:
			[ :each | ^ self selectSourceFor: (parserStackList items at: each) last ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateParserStack [
	parserStackList notNil
		ifTrue: [ | items |
			items := self session parserStack.
			parserStackList items: items.
			((1 to: items size)
				detect: [ :i | (items at: i) last ~= '' ]
				ifNone: [  ]) ifNotNil: [ :i | parserStackList selectOne: i ] ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateParserStates [
	stateActionsList notNil
		ifTrue: [ stateActionsList items: self session potentialStateActions ]
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateScanner [
	| scanner start end success attributes |
	self showContext.
	(parserTab notNil and: [ parserTab viewModel isSelected ])
		ifTrue: [ self enqueueTask: (BlTaskAction new action: [ scannerTab select ]) ].
	scanner := self session scanner.
	success := scanner matchActions notNil.
	success
		ifFalse: [ ^ self ].
	start := scanner debugStart.
	end := scanner debugEnd.
	attributes := self acceptAttributes.
	self highlightFrom: start + 1 to: end with: attributes
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateScannerProperties [
	scannerPropertiesList notNil
		ifTrue: [ scannerPropertiesList items: self session scannerProperties ]
]
