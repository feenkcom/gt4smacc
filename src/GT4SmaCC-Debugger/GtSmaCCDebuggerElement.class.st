Class {
	#name : #GtSmaCCDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'scannerPropertiesList',
		'parserStackList',
		'stateActionsList',
		'sourceEditor'
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

{ #category : #'tools registry' }
GtSmaCCDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 10.
]

{ #category : #accessing }
GtSmaCCDebuggerElement class >> sessionClass [
	^ SmaCCParserDebugSession
]

{ #category : #callbacks }
GtSmaCCDebuggerElement >> actOnDebugSessionChanged [
	self buildUI
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildDetails [
	| element |
	element := BlElement new
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element addChild: self buildDetailsInspector.
	element addChild: self buildSource.
	^ element
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildDetailsInspector [
	| parserTab scannerTab tabGroup |
	parserTab := BrTabModel new
		add: (BrLabelModel text: 'Parser');
		stencil: [ self buildParserElement ].
	scannerTab := BrTabModel new
		add: (BrLabelModel text: 'Scanner');
		stencil: [ self buildScannerElement ].
	tabGroup := BrTabGroupModel
		with:
			{parserTab.
			scannerTab}.
	tabGroup tabs
		do: [ :each | 
			BlElement new
				look: BrMaterialTabLabelledLook;
				viewModel: each ].
	^ BlElement new
		padding: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ];
		look: BrMaterialTabGroupLook;
		viewModel: tabGroup
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserActions [
	stateActionsList := BrColumnedList new.
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
				look: BrGlamorousLabelLook new;
				text: text;
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
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
				look: BrGlamorousLabelLook new;
				text: text;
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	^ stateActionsList
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserElement [
	| element |
	element := BlElement new.
	element
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element addChild: self buildParserStack.
	element addChild: self buildParserActions.
	self updateContents.
	^ element
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserStack [
	parserStackList := BrColumnedList new.
	parserStackList
		when: BrSelectionChanged
		do: [ :event | 
			event
				selectedDo:
					[ :each | self selectSourceFor: (parserStackList items at: each first) last ] ].
	parserStackList column
		title: 'Symbol';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: (each first ifNil: [ '' ]);
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	parserStackList column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: BrGlamorousLabelLook new;
				text: each last displayString;
				hMatchParent;
				vMatchParent;
				margin:
					(BlInsets
						top: 3
						left: 10
						bottom: 3
						right: 0) ].
	^ parserStackList
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildParserToolbarActions [
	| buttons |
	buttons := (self
		actionsForPragmas: self parserDebuggingActionsPragmas)
		, (self actionsForPragmas: self scannerDebuggingActionsPragmas)
		collect: [ :aDebuggingAction | 
			| actionButton |
			actionButton := BrButton new
				look: BrGlamorousButtonWithIconLook;
				label: aDebuggingAction label;
				action: [ aDebuggingAction execute.
					aDebuggingAction needsUpdate
						ifTrue: [ self updateContents ] ].
			aDebuggingAction icon
				ifNotNil: [ :anIcon | actionButton icon: aDebuggingAction icon asElement ].
			actionButton ].
	^ buttons
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildScannerElement [
	| element |
	element := BlElement new.
	element
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: 10);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element addChild: self buildScannerProperties.
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
				look: BrGlamorousLabelLook new;
				text: each first;
				hMatchParent;
				vMatchParent;
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
				look: BrGlamorousLabelLook new;
				text: each last displayString;
				hMatchParent;
				vMatchParent;
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
	editorElement := BrEditorElement new.
	sourceEditor := BrTextEditor new.
	sourceEditor text: text readonly.
	editorElement editor: sourceEditor.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ editorElement
]

{ #category : #'building widgets' }
GtSmaCCDebuggerElement >> buildTabGroupForElement: anElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		look: BrGlamorousTabLook new invisibleBar;
		label: self session name;
		stencil: [ BrValuableStencil from: anElement ];
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		actionsStencil: [ | aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrGlamorousToolbarLook new.
			self buildParserToolbarActions
				do: [ :anAction | aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		look:
			(BrMaterialTabGroupLook new
				headerBackground: BrGlamorousColors defaultButtonBorderColor);
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
				background: BrGlamorousColors errorBackgroundColor;
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

{ #category : #accessing }
GtSmaCCDebuggerElement >> currentContext [
	^ self interruptedContext
]

{ #category : #accessing }
GtSmaCCDebuggerElement >> currentInputSelectionInterval [
	sourceEditor isNil
		ifTrue: [ ^ 1 to: 0 ].
	sourceEditor selection do: [ :each | ^ each interval ].
	sourceEditor cursors
		do: [ :each | ^ each position to: each position ].
	^ 1 to: 0
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

{ #category : #private }
GtSmaCCDebuggerElement >> parserDebuggingActionsPragmas [
	^ #(gtSmaCCDebuggingParserAction)
]

{ #category : #private }
GtSmaCCDebuggerElement >> scannerDebuggingActionsPragmas [
	^ #(gtSmaCCDebuggingInputAction)
]

{ #category : #private }
GtSmaCCDebuggerElement >> selectSourceFor: anObject [
	| interval |
	interval := self session tokenIntervalFor: anObject.
	interval isNil
		ifTrue: [ ^ self ].
	sourceEditor selecter
		overwrite;
		from: interval first - 1 to: interval last;
		select
]

{ #category : #'private-updating' }
GtSmaCCDebuggerElement >> updateContents [
	parserStackList notNil
		ifTrue: [ | items |
			items := self session parserStack.
			parserStackList items: items.
			((1 to: items size)
				detect: [ :i | (items at: i) last ~= '' ]
				ifNone: [  ]) ifNotNil: [ :i | parserStackList selectOne: i ] ].
	stateActionsList notNil
		ifTrue: [ stateActionsList items: self session potentialStateActions ].
	scannerPropertiesList notNil
		ifTrue: [ scannerPropertiesList items: self session scannerProperties ]
]
