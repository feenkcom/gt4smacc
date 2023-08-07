Class {
	#name : #GtSmaCCTransformationToolkitDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'nodeHighlight',
		'codeHighlight',
		'currentContext',
		'topContext'
	],
	#classInstVars : [
		'availableAutomatically'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> availableAutomatically [
	^ availableAutomatically ifNil: [ true ]
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> defaultTitle [
	^ 'SmaCCTransformations'
]

{ #category : #testing }
GtSmaCCTransformationToolkitDebuggerElement class >> handlesContext: aContext [
	^ SmaCCTransformationToolkitDebugSession handlesContext: aContext
]

{ #category : #'class initialization' }
GtSmaCCTransformationToolkitDebuggerElement class >> initialize [
	self register
]

{ #category : #'tools registry' }
GtSmaCCTransformationToolkitDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 900.
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> sessionClass [
	^ SmaCCTransformationToolkitDebugSession
]

{ #category : #callbacks }
GtSmaCCTransformationToolkitDebuggerElement >> actOnDebugSessionChanged [
	self buildUI
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> buildUI [
	self removeChildren.
	self addChild: self tabGroupElement.
	self updateOriginalSource.
	self updateContents
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> codeObjectForContext: aContext andRewrite: aRewrite [
	(aRewrite isKindOf: SmaCCRewriteMethodDefinition) ifTrue: [ ^ aRewrite ].
	^ (self isTransformation: aContext andRewrite: aRewrite) ifTrue: [ aRewrite transformation ] ifFalse: [ aRewrite match ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> contextVariables [
	| stackPosition vars receiver |
	receiver := self currentContext receiver.
	vars := receiver class allInstVarNames
		collect: [ :each | each -> ([ receiver instVarNamed: each ] on: Error do: [ :ex | ex return ]) ].
	vars := vars asOrderedCollection.
	self currentContext tempNames
		do: [ :each | vars add: each -> ([ self currentContext tempNamed: each ] on: Error do: [ :ex | ex return ]) ].
	vars sort: [ :a :b | a key < b key ].
	vars addFirst: 'self' -> receiver.
	stackPosition := 0.
	self currentContext stackPtr
		to: self currentContext numTemps + 1
		by: -1
		do:
			[ :i | 
			vars
				add:
					('stack top' , (stackPosition > 0 ifTrue: [ ' - ' , stackPosition printString ] ifFalse: [ '' ]))
						-> (self currentContext at: i).
			stackPosition := stackPosition + 1 ].
	^ vars
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> currentContext [
	^ currentContext ifNil: [ self interruptedContext ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> debuggerActions [
	^ {SmaCCSendRuleDebugAction.
		SmaCCStepRuleDebugAction.
		SmaCCStepToNextNodeAction.
		SmaCCStepToNextRewriteAction} collect: [ :each | each forDebugger: self ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> detailsElement [
	| element top bottom |
	element := (BrVerticalPane new)
		padding: (BlInsets all: 5);
		matchParent.
	top := (BrHorizontalPane new)
		matchParent;
		aptitude: BrGlamorousWithVerticalResizerAptitude new beBottom.
	top addChild: self stackElement.
	top addChild: self inspectorElement.
	bottom := BrHorizontalPane new matchParent.
	bottom addChild: self originalSourceElement as: #originalSource.
	bottom addChild: self newSourceElement as: #newSource.
	element
		addChild: top;
		addChild: bottom.
	^ element
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> equivalentNodeTo: aNode in: otherTree [
	| equivParent nodeIndex equivNode |
	aNode isMethod ifTrue: [ ^ otherTree ].
	(aNode parent isReturn and: [ aNode parent parent parent isMethod ])
		ifTrue:
			[ equivNode := otherTree isSequence ifTrue: [ otherTree statements last ] ifFalse: [ otherTree ].
			^ equivNode isReturn ifTrue: [ equivNode value ] ifFalse: [ equivNode ] ].
	aNode parent isMethod ifTrue: [ otherTree isSequence ifTrue: [ ^ otherTree ] ifFalse: [ ^ otherTree parent ] ].
	equivParent := self equivalentNodeTo: aNode parent in: otherTree.
	equivParent ifNil: [ ^ nil ].
	nodeIndex := aNode parent children identityIndexOf: aNode.
	^ equivParent children at: nodeIndex ifAbsent: [ nil ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> executeAction: aDebuggingAction [
	aDebuggingAction execute.
	self updateContents
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> highlightAndScroll: editor interval: interval using: attribute [
	| lineNumber |
	editor text clearAttributes: [ :each | each == attribute ].
	interval notEmpty
		ifTrue:
			[ editor text
				attributes: {attribute}
				from: interval first
				to: interval last ].
	lineNumber := editor text asString lineNumberCorrespondingToIndex: interval first.
	editor scrollToPosition: lineNumber
]

{ #category : #initialization }
GtSmaCCTransformationToolkitDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo:
				[ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
	codeHighlight := (BlTextDecorationAttribute new)
		underline;
		color: BrGlamorousColors textHighlightColor;
		thickness: 3;
		beNotOverwritableByStyler.
	nodeHighlight := codeHighlight.
	self
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										key: BlKeyboardKey F10;
										build);
						action: [ :anEvent :aShortcut | self executeAction: (SmaCCStepRuleDebugAction forDebugger: self) ]);
		addShortcut:
				((BlShortcutWithAction new)
						combination:
								((BlKeyCombination builder)
										key: BlKeyboardKey F11;
										build);
						action: [ :anEvent :aShortcut | self executeAction: (SmaCCSendRuleDebugAction forDebugger: self) ])
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> inspectorElement [
	^ (BrTabGroup new)
		aptitude: BrGlamorousTabGroupAptitude new + BrGlamorousWithHorizontalResizerAptitude new beLeft;
		margin: (BlInsets all: 5);
		width: 250;
		addTab:
				((BrTab new)
						aptitude: BrGlamorousTabAptitude new;
						label: 'Variables';
						stencil: [ self variableInspectorElement ]);
		addTab:
				((BrTab new)
						aptitude: BrGlamorousTabAptitude new;
						label: 'Properties';
						stencil: [ self propertyInspectorElement ])
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> inspectorListElement [
	| list |
	list := BrColumnedList new.
	list margin: (BlInsets all: 5).
	list border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	list addEventHandler: (GtPhlowListToSelectHandler new transformation: [ :variableNode | variableNode value ]).
	list rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new.
	(list column)
		title: 'Name';
		cellStencil:
				[ (BrLabel new)
						aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
						hMatchParent;
						vFitContent;
						margin:
								(BlInsets
										top: 3
										left: 10
										bottom: 3
										right: 0) ];
		dataBinder: [ :aCellElement :aVariableNode | aCellElement text: aVariableNode key asRopedText ].
	(list column)
		title: 'Value';
		cellStencil:
				[ (BrLabel new)
						aptitude: BrGlamorousLabelAptitude new;
						hMatchParent;
						vFitContent;
						margin:
								(BlInsets
										top: 3
										left: 10
										bottom: 3
										right: 0) ];
		dataBinder:
				[ :aCellElement :aVariableNode | 
					| aRawValue |
					aRawValue := aVariableNode value.
					aCellElement
						text:
							([ aRawValue gtDisplayString asRopedText ]
								on: Error , Halt
								do: [ :error | error messageText asRopedText foreground: Color red ]) ].
	^ list
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> intervalFromMethodNode: aNode inSource: aString [
	| otherTree otherNode |
	otherTree := RBParser parseExpression: aString onError: [ :msg :pos | ^ 1 to: 0 ].
	otherNode := self equivalentNodeTo: aNode in: otherTree.
	otherNode ifNil: [ ^ 1 to: 0 ].
	^ otherNode start to: otherNode stop
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> isTransformation: aContext andRewrite: aRewrite [
	^ aRewrite transformation method == aContext method
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> newSourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		aptitude: BrGlamorousCodeEditorAptitude;
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> originalSourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		aptitude: BrGlamorousCodeEditorAptitude;
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> outputSelectionIntervalFor: aContext [
	| source stop matchContext match start |
	(aContext isNil or: [ (aContext receiver isKindOf: SmaCCRewriteMatchContext) not ]) ifTrue: [ ^ 1 to: 0 ].
	matchContext := aContext receiver.
	source := matchContext source.
	match := matchContext match.
	start := matchContext startIndexFor: match.
	stop := matchContext stopIndexFor: match.
	^ (source stringIndexFor: start) to: (source stringIndexFor: stop)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> propertyInspectorElement [
	| list |
	list := self inspectorListElement.
	list items: self propertyVariables.
	^ (BlElement new)
		constraintsDo:
				[ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
		addChild: list as: #propertyInspector;
		yourself
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> propertyVariables [
	| receiver |
	receiver := self currentContext receiver.
	^ receiver class classPool associations asSortedCollection: [ :a :b | a key < b key ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> sourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> sourceForContext: aContext andRewrite: aRewrite [
	aContext ifNil: [ ^ '' ].
	^ (self codeObjectForContext: aContext andRewrite: aRewrite) source
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> sourceSelectionIntervalForContext: aContext andRewrite: aRewrite [
	| node |
	aContext ifNil: [ ^ 1 to: 0 ].
	node := aContext method sourceNodeForPC: aContext pc.
	^ (aRewrite isKindOf: SmaCCRewriteMethodDefinition)
		ifTrue: [ node sourceInterval ]
		ifFalse: [ self intervalFromMethodNode: node inSource: (self sourceForContext: aContext andRewrite: aRewrite) ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> stackElement [
	| list |
	list := (BrSimpleList new)
		padding: (BlInsets all: 5);
		matchParent;
		itemStencil:
				[ (BrExpander new)
						margin:
								(BlInsets
										top: 3
										left: 3
										bottom: 3
										right: 8);
						padding: (BlInsets all: 3);
						aptitude:
								((GtCoderExpanderAptitude new)
										borderWidth: 0;
										padding:
												(BlInsets
														top: 1
														left: 10
														bottom: 1
														right: 10));
						hMatchParent;
						vFitContent ];
		itemDataBinder:
				[ :expander :each :index | 
					| isBlock labelString |
					isBlock := each last isBlockContext.
					labelString := ((isBlock ifTrue: [ '[' ] ifFalse: [ '' ]) , each first displayString
						, (isBlock ifTrue: [ ']' ] ifFalse: [ '' ]) gtDisplayString) asRopedText bold.
					expander
						header:
								[ (BrLabel new)
										aptitude: BrGlamorousLabelAptitude;
										vFitContent;
										hMatchParent;
										text: labelString ];
						content:
								[ | editor |
									editor := self textElementForContext: each last andRewrite: each first.
									editor enqueueTask: (BlTaskAction new action: [ editor requestFocus ]).
									(BrVerticalPane new)
										hMatchParent;
										vFitContent;
										addChild:
												((BrLabel new)
														aptitude: BrGlamorousLabelAptitude;
														vFitContent;
														hMatchParent;
														text: labelString);
										addChild: editor as: #editor ];
						expanded: index = 1 ].
	^ (BlElement new)
		margin: (BlInsets all: 5);
		constraintsDo:
				[ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
		addChild: list as: #stack;
		yourself
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> stylerFor: aRewrite [
	| styler |
	styler := GtCompositeSmaCCASTStyler forParser: GtPharoParser.
	styler
		stylers:
			{GtSmaCCPharoStyler new.
				GtPharoDynamicHighlightStyler new}.
	(aRewrite isKindOf: SmaCCRewriteMethodDefinition)
		ifFalse: [ styler startingState: GtPharoParser startingStateForMethodSequence ].
	^ styler
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> tabGroupElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: [ self detailsElement ];
		padding:
				(BlInsets
						top: 15
						right: 0
						bottom: 15
						left: 10);
		toolbarStencil:
				[ | aToolbar |
					aToolbar := BrToolbar new.
					aToolbar aptitude: BrGlamorousToolbarAptitude new.
					self toolbarButtons do: [ :anAction | aToolbar addItem: anAction ].
					aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude: (BrGlamorousTabGroupAptitude new headerBackground: self theme header defaultBackgroundColor);
		addTab: tab;
		matchParent;
		addChild:
				((BlElement new)
						constraintsDo:
								[ :c | 
									c ignoreByLayout.
									c horizontal matchParent.
									c vertical exact: 5 ];
						background: self theme status errorBackgroundColor;
						yourself).
	^ tabGroup
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> textElementForContext: aContext andRewrite: aRewrite [
	| element |
	element := BrEditor new.
	element aptitude: BrGlamorousCodeEditorAptitude.
	element editor text: (self sourceForContext: aContext andRewrite: aRewrite) asRopedText.
	element margin: (BlInsets all: 3).
	element matchParent.
	element border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element
		when: BlFocusInEvent
		do:
			[ currentContext := aContext.
			self updateInspectors.
			self updateNewSourceHighlight.
			self updateOriginalSourceHighlight ].
	element editor styler: (self stylerFor: aRewrite).
	self
		highlightAndScroll: element
		interval: (self sourceSelectionIntervalForContext: aContext andRewrite: aRewrite)
		using: codeHighlight.
	^ element
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> toolbarButtons [
	| buttons |
	buttons := self debuggerActions
			collect: [ :aDebuggingAction | 
				| actionButton |
				actionButton := BrButton new
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: aDebuggingAction name;
						action: [ self executeAction: aDebuggingAction ].
				aDebuggingAction icon
					ifNotNil: [ :anIcon | actionButton icon: aDebuggingAction icon asElement ].
				actionButton ].
	^ buttons
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateContents [
	self updateStack.
	self updateNewSource.
	self updateInspectors
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateInspectors [
	self updateVariableInspector.
	self updatePropertyInspector
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateNewSource [
	self
		childNamed: #newSource
		ifFound:
			[ :editor | editor editor text asString ~= self session newSource ifTrue: [ editor editor text: self session newSource asRopedText ] ].
	self updateNewSourceHighlight
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateNewSourceHighlight [
	self
		childNamed: #newSource
		ifFound:
			[ :editor | 
			| interval |
			interval := self outputSelectionIntervalFor: self currentContext.
			self
				highlightAndScroll: editor
				interval: interval
				using: nodeHighlight ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateOriginalSource [
	self childNamed: #originalSource ifFound: [ :editor | editor editor text: self session originalSource asRopedText ].
	self updateOriginalSourceHighlight
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateOriginalSourceHighlight [
	self
		childNamed: #originalSource
		ifFound:
			[ :editor | 
			| interval |
			interval := (self currentContext receiver isKindOf: SmaCCRewriteMatchContext)
				ifTrue: [ self currentContext receiver match sourceInterval ]
				ifFalse: [ 1 to: 0 ].
			self
				highlightAndScroll: editor
				interval: interval
				using: nodeHighlight ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updatePropertyInspector [
	self childNamed: #propertyInspector ifFound: [ :list | list items: self propertyVariables ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateStack [
	currentContext := nil.
	self interruptedContext == topContext
		ifTrue:
			[ self
				childNamed: #stack
				ifFound:
					[ :list | 
					list
						childNamed: #editor
						ifFound:
							[ :editor | 
							self
								highlightAndScroll: editor
								interval:
									(self sourceSelectionIntervalForContext: topContext andRewrite: (debuggingSession rewriteForContext: topContext))
								using: codeHighlight ] ] ]
		ifFalse:
			[ topContext := nil.
			self
				childNamed: #stack
				ifFound:
					[ :list | 
					| stream contextStream |
					contextStream := GtSmaCCTransformationStackStream onContext: debuggingSession context.
					(contextStream asyncSimilarCopy next then: [ :value | topContext := value value ]) await.
					stream := (contextStream
						collect:
							[ :each | 
							{debuggingSession rewriteForContext: each.
								each} ]) select: [ :each | each first notNil ].
					list
						itemsProvider:
							((BrStreamItemsProvider new)
								stream: stream asyncSimilarCopy;
								preloadAmount: 1) ] ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateVariableInspector [
	self
		childNamed: #variableInspector
		ifFound:
			[ :list | 
			| vars |
			vars := self contextVariables.
			list items: vars ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> variableInspectorElement [
	| list |
	list := self inspectorListElement.
	list items: self contextVariables.
	^ (BlElement new)
		constraintsDo:
				[ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
		addChild: list as: #variableInspector;
		yourself
]
