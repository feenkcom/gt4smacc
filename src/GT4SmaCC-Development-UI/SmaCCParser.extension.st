Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> debug: aString startingAt: anInteger from: anElement [
	| process context debuggingSession |
	context := [ self parse: aString startingAt: anInteger ] asContext.
	process := Process forContext: context priority: Processor userInterruptPriority.
	debuggingSession := process newDebugSessionNamed: 'Debug parse' startedAt: process suspendedContext.
	[ SmaCCParserDebugSession handlesContext: debuggingSession context ] whileFalse: [ debuggingSession stepInto ].
	process debug
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtAnnotationsFor: aView context: aDictionary [
	<gtClassView>
	| coder |
	self parserDefinitionString isEmpty
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
SmaCCParser class >> gtGrammarFor: aView context: aDictionary [
	<gtView>
	<gtClassView>
	| coder |
	self parserDefinitionString isEmpty ifTrue: [ ^ aView empty ].
	coder := aDictionary
			at: #coder
			ifAbsentPut: [ GtSmaCCGrammarCoder onParser: self ].
	^ aView explicit
		title: 'Grammar';
		priority: 1;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add'
			content: [ :element | coder addMenuItemsElement ];
		stencil: [ coder asElement ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtSourceFor: aView context: aDictionary [
	<gtView>
	<gtClassView>
	| coder |
	self parserDefinitionString isEmpty ifTrue: [ ^ aView empty ].
	coder := aDictionary
			at: #coder
			ifAbsentPut: [ GtSmaCCGrammarCoder onParser: self ].
	^ aView explicit
		title: 'Source';
		priority: 6;
		stencil: [ | element |
			element := GtSmaCCGrammarElement onGrammar: coder grammar.
			element
				when: BlElementAddedToSceneGraphEvent
				do: [ :event | 
					coder grammar source = element source
						ifFalse: [ element sourceEditor text: coder grammar source asRopedText ] ].
			element
				when: BlElementRemovedFromSceneGraphEvent
				do: [ :event | 
					coder grammar source = element source
						ifFalse: [ coder grammar updateSource: element source ] ].
			element ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtTestElement [
	| element actionBar editorElement startingStateButton currentState |
	currentState := #defaultStartingState.
	element := BrVerticalPane new.
	element margin: (BlInsets all: 5).
	element matchParent.
	editorElement := BrEditor new.
	editorElement border: (BlBorder paint: (Color lightGray alpha: 0.5)).
	editorElement padding: (BlInsets all: 2).
	editorElement matchParent.
	editorElement aptitude: BrGlamorousCodeEditorAptitude.
	self gtStyler ifNotNil: [ :styler | editorElement editor styler: styler ].
	actionBar := (BrToolbar new)
		padding: (BlInsets top: 3 left: 3);
		aptitude: BrGlamorousToolbarAptitude new;
		addItem:
				((BrButton new)
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: 'Inspect';
						icon: BrGlamorousVectorIcons inspect;
						action:
								[ :button | 
									editorElement editor text clearAttributes: [ :each | each isKindOf: GtSourceCoderErrorAttribute ].
									[ button phlow
										spawnObject: (self parse: editorElement editor text asString startingAt: (self perform: currentState)) ]
										on: SmaCCParserError
										do: [ :ex | ex gtDisplayErrorIn: editorElement editor ] ]);
		addItem:
				((BrButton new)
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: 'Debug';
						icon: BrGlamorousVectorIcons debug;
						action:
								[ :button | 
									self
										debug: editorElement editor text asString
										startingAt: (self perform: currentState)
										from: button ]).
	self startingStateNames size > 1
		ifTrue:
			[ currentState := ('startingStateFor'
				,
					(self startingStateNames
						detect: [ :each | (self perform: ('startingStateFor' , each) asSymbol) = 1 ]
						ifNone: [ self startingStateNames first ])) asSymbol.
			startingStateButton := BrButton new.
			startingStateButton aptitude: BrGlamorousButtonWithLabelAptitude.
			startingStateButton label: (currentState allButFirst: 16).
			startingStateButton beSmallSize.
			startingStateButton margin: (BlInsets all: 2).
			startingStateButton
				addAptitude:
					(BrGlamorousWithExplicitDropdownAptitude
						handle:
							[ (BrButton new)
								beSmallSize;
								label: (currentState allButFirst: 16);
								aptitude:
										BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonWithLabelTooltipAptitude - BrGlamorousButtonExteriorAptitude ]
						content:
							[ | list |
							list := BrSimpleList new.
							list fitContent.
							list
								stencil:
									[ :each | 
									(BrLabel new)
										aptitude: BrGlamorousLabelAptitude new + BrGlamorousListItemAptitude;
										padding:
												(BlInsets
														top: 3
														left: 3
														bottom: 3
														right: 8);
										text: each;
										hMatchParent;
										vFitContent;
										when: BlClickEvent
											do:
												[ :anEvent | 
													anEvent consumed: true.
													currentState := ('startingStateFor' , each) asSymbol.
													startingStateButton label: each.
													startingStateButton dispatchEvent: (BrDropdownHideWish new anchor: startingStateButton) ];
										yourself ].
							list items: self startingStateNames.
							list ]).
			actionBar addChild: startingStateButton ].
	element addChild: editorElement as: #parserTestInput.
	element addChild: actionBar as: #parserTestActions.
	^ element
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtTestFor: aView [
	<gtView>
	<gtClassView>
	self parserDefinitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Test';
		priority: 7;
		stencil: [ self gtTestElement ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtUnknownProductionType: aGtAdvice [
	<gtAdvice>
	| types names |
	(self class includesSelector: #definitionComment) ifFalse: [ ^ aGtAdvice none ].
	types := self symbolTypes.
	names := self symbolNames.
	^ aGtAdvice asyncStream
		priority: 1;
		description: [ :each | (each , ': type could not be determined.') asRopedText ];
		compute: [ ((1 to: (types size min: names size)) asAsyncStream
				select: [ :i | (types at: i) = #Object ]) collect: [ :i | names at: i ] ];
		action: [ :each | GtSelectRuleAdviceAction forParser: self ruleName: each ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> simulateParse: inputString fromRule: ruleName [
	| simulator |
	simulator := SmaCCParserSimulator on: self parserDefinitionString.
	simulator setupFor: ruleName.
	^ simulator simulateParse: inputString
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> simulationError [
	<gtExample>
	Smalltalk
		at: #GtPharoParser
		ifPresent: [ :each | 
			| source |
			source := '[:each | each * 2'.
			self assert: (each simulationParses: source fromRule: 'Block') not.
			[ each simulateParse: source fromRule: 'Block' ]
				on: SmaCCParserSimulationError
				do: [ :ex | ^ ex ].
			self error: 'Should not get here' ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> simulationExample [
	<gtExample>
	^ Smalltalk
		at: #GtPharoParser
		ifPresent: [ :each | 
			| source |
			source := '[:each | each * 2]'.
			self assert: (each simulationParses: source fromRule: 'Block').
			each simulateParse: source fromRule: 'Block' ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> simulationParses: inputString fromRule: ruleName [
	^ [ self simulateParse: inputString fromRule: ruleName.
	true ]
		on: Error
		do: [ :ex | ex return: false ]
]
