Class {
	#name : #SmaCCParserGeneratorPresentation,
	#superclass : #GLMCompositePresentation,
	#instVars : [
		'parserClassName',
		'scannerClassName',
		'allowUnicode',
		'codeGeneratorType',
		'savedDefinition',
		'type',
		'viewItemSets',
		'viewSymbols',
		'tabGroup',
		'definitionEditor',
		'messagesEditor',
		'symbolsEditor',
		'itemSetsEditor',
		'testEditor',
		'lastTabPage',
		'definitionAST',
		'testFiles',
		'testFileDirectory'
	],
	#classVars : [
		'ShowPrecedenceConflicts'
	],
	#category : #'GT-SmaCC-Development-UI'
}

{ #category : #'class initialization' }
SmaCCParserGeneratorPresentation class >> initialize [
	ShowPrecedenceConflicts := false
]

{ #category : #private }
SmaCCParserGeneratorPresentation class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #'SmaCC Parser Generator (GT)')
		parent: #Tools;
		order: 0.555;
		action: [ self open ]
]

{ #category : #opening }
SmaCCParserGeneratorPresentation class >> open [
	^ self new
		openOn: '';
		yourself
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> addSourceShortcutsOn: element [
	element
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key r;
						build);
				action: [ self renameSymbolOn: element ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key u;
						build);
				action: [ self moveDefinitionUp ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key d;
						build);
				action: [ self moveDefinitionDown ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key e;
						build);
				action: [ self extractSourceIn: element ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key i;
						build);
				action: [ self inlineSource ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key g;
						build);
				action: [ self gotoDefinitionIn: element ])
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> addTestShortcutsOn: element [
	element
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key d;
						build);
				action: [ self debugParse ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key e;
						build);
				action: [ self parse ]);
		addShortcut:
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: Key i;
						build);
				action: [ self parseAndInspect ])
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> annotationsLabel [
	^ 'Annotations'
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildAnnotationTabOn: stacker [
	stacker aPane: #annotations.
	stacker transmit
		fromOutsidePort: #definitionSource;
		to: #annotations;
		andShow: [ :composite | 
			| tabulator |
			composite title: self annotationsLabel.
			tabulator := composite tabulator.
			tabulator
				column: #rules;
				column: #value span: 2.
			tabulator transmit
				to: #rules;
				andShow: [ :presentation | 
					| items |
					items := self definitionItems.
					self buildRuleList: items in: presentation ].
			tabulator transmit
				from: #rules port: #selection;
				to: #value;
				andShow: [ :presentation :rule | 
					presentation pager
						show: [ :pres :each | 
							each notNil
								ifTrue: [ each buildInterfaceIn: pres ] ];
						startOn: rule ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildButtonItemsOn: presentation [
	presentation
		act: [ :each | self findParserClass ] entitled: 'Load';
		act: [ :each | self compile ] entitled: 'Save';
		act: [ :each | self close ] entitled: 'Close'
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildItemSetsTabOn: stacker [
	stacker aPane: #itemSets.
	stacker transmit
		to: #itemSets;
		andShow: [ :presentation | 
			presentation title: self itemSetsLabel.
			presentation bloc element: [ self textEditorElementOn: itemSetsEditor ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildMenuItemsOn: presentation [
	presentation
		dynamicActions: [ :ignore | 
			{(SmaCCGLMAction new
				category: 'Options';
				action: [ :each | self setScannerClass ];
				title:
					'Scanner Class'
						,
							(scannerClassName isNil
								ifTrue: [ '...' ]
								ifFalse: [ ' (' , scannerClassName , ')...' ]);
				yourself).
			(SmaCCGLMAction new
				category: 'Options';
				action: [ :each | self setParserClass ];
				title:
					'Parser Class'
						,
							(parserClassName isNil
								ifTrue: [ '...' ]
								ifFalse: [ ' (' , parserClassName , ')...' ]);
				yourself).
			(SmaCCGLMAction new
				isMenu: true;
				isButton: false;
				category: 'Options';
				action: [ :each | self useUnicode ];
				icon:
					(self
						iconNamed:
							(self isUnicode
								ifTrue: [ #checkBoxOn ]
								ifFalse: [ #checkBoxOff ]));
				title: 'Allow Unicode Characters';
				shouldShowTitle: true;
				yourself).
			(SmaCCGLMAction new
				isMenu: true;
				isButton: false;
				category: 'Options';
				action: [ :each | self setLALR1 ];
				icon:
					(self
						iconNamed:
							(self isLALR1
								ifTrue: [ #checkBoxOn ]
								ifFalse: [ #checkBoxOff ]));
				title: 'LALR(1)';
				shouldShowTitle: true;
				yourself).
			(SmaCCGLMAction new
				isMenu: true;
				isButton: false;
				category: 'Options';
				action: [ :each | self setLR1 ];
				icon:
					(self
						iconNamed:
							(self isLR1
								ifTrue: [ #checkBoxOn ]
								ifFalse: [ #checkBoxOff ]));
				title: 'LR(1)';
				shouldShowTitle: true;
				yourself).
			(SmaCCGLMAction new
				isMenu: true;
				isButton: false;
				category: 'View';
				action: [ :each | self viewSymbolsClicked ];
				icon:
					(self
						iconNamed:
							(viewSymbols
								ifTrue: [ #checkBoxOn ]
								ifFalse: [ #checkBoxOff ]));
				title: 'Symbols';
				shouldShowTitle: true;
				yourself).
			(SmaCCGLMAction new
				isMenu: true;
				isButton: false;
				category: 'View';
				action: [ :each | self viewItemSetsClicked ];
				icon:
					(self
						iconNamed:
							(viewItemSets
								ifTrue: [ #checkBoxOn ]
								ifFalse: [ #checkBoxOff ]));
				title: 'Item Sets';
				shouldShowTitle: true;
				yourself)} ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildMessagesTabOn: stacker [
	stacker aPane: #messages.
	stacker transmit
		to: #messages;
		andShow: [ :presentation | 
			presentation title: self messagesLabel.
			presentation bloc element: [ self textEditorElementOn: messagesEditor ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildRuleList: items in: presentation [
	^ presentation fastList
		enableFilter: [ :each :text | each matches: text ];
		display: items;
		format: [ :each | each displayString ];
		tags: [ :each | each tags ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildScannerTestTabOn: stacker [
	stacker aPane: #scannerTest.
	stacker transmit
		fromOutsidePort: #definitionSource;
		to: #scannerTest;
		andShow: [ :composite | 
			| tabulator |
			composite title: self scannerTestLabel.
			tabulator := composite tabulator.
			tabulator
				column: #tokens;
				column: #tokenTest span: 2.
			tabulator transmit
				to: #tokens;
				andShow: [ :presentation | 
					| items |
					items := self definitionItems select: [ :each | each isKindOf: SmaCCTokenRuleNode ].
					self buildRuleList: items in: presentation ].
			tabulator transmit
				from: #tokens port: #selection;
				to: #tokenTest;
				andShow: [ :presentation :rule | 
					rule notNil
						ifTrue: [ presentation bloc
								element: [ | element definitionText definitionElement tester testElement simulator |
									simulator := SmaCCRegexSimulator on: rule topParent tokenName: rule name value.
									definitionText := rule source asRopedText.
									definitionText := FkSmaCCStyler new style: definitionText.
									element := BlElement new.
									element
										constraintsDo: [ :c | 
											c horizontal matchParent.
											c vertical matchParent ];
										layout: BlFlowLayout vertical.
									element
										addChild:
											((BlTextElement text: 'Definition:' asRopedText bold)
												margin: (BlInsets all: 7);
												yourself).
									definitionElement := BrEditorElement new.
									definitionElement
										border: (BlBorder paint: Color lightGray);
										constraintsDo: [ :c | 
											c horizontal matchParent.
											c vertical fitContent ];
										editor:
											(BrTextEditor new
												text: definitionText;
												yourself);
										margin: (BlInsets all: 7).
									element addChild: definitionElement.
									element
										addChild:
											((BlTextElement text: 'Test:' asRopedText bold)
												margin: (BlInsets all: 7);
												yourself).
									tester := BrTextEditor new.
									tester
										when: BrTextEditorDeletedEvent
											do: [ :anEvent | 
											self
												simulateUsing: simulator
												tokenEditor: definitionElement editor
												testEditor: tester
												index: anEvent fromIndex - 1 ];
										when: BrTextEditorInsertedEvent
											do: [ :anEvent | 
											self
												simulateUsing: simulator
												tokenEditor: definitionElement editor
												testEditor: tester
												index: anEvent index + 1 ].
									testElement := BrEditorElement new.
									testElement
										border: (BlBorder paint: Color lightGray);
										constraintsDo: [ :c | 
											c horizontal matchParent.
											c vertical fitContent ];
										editor: tester;
										margin: (BlInsets all: 7).
									element addChild: testElement.
									element ] ] ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildSourceTabOn: stacker [
	stacker aPane: #source.
	stacker transmit
		to: #source;
		andShow: [ :presentation | 
			presentation title: self sourceLabel.
			presentation bloc
				element: [ | element completionStrategy completionController styler |
					element := self textEditorElementOn: definitionEditor.
					self addSourceShortcutsOn: element.
					completionStrategy := GtWeightedStringsCompletionStrategy new.
					completionController := GtCompletionController on: element strategy: completionStrategy.
					completionController install.
					styler := FkSmaCCStyler
						for:
							([ self scannerClass ]
								on: Error
								do: [ :ex | ex return: SmaCCScanner ]).
					element editor styler: styler.
					styler when: BrTextStyledEvent do: [ :event | completionStrategy completions: styler completions ].
					element ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildSymbolsTabOn: stacker [
	stacker aPane: #symbols.
	stacker transmit
		to: #symbols;
		andShow: [ :presentation | 
			presentation title: self symbolsLabel.
			presentation bloc element: [ self textEditorElementOn: symbolsEditor ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildTestFilesTabOn: stacker [
	stacker aPane: #testFiles.
	stacker transmit
		to: #testFiles;
		andShow: [ :presentation | 
			| tabulator |
			presentation title: 'Test Files'.
			tabulator := presentation tabulator.
			tabulator
				column: #files;
				column: #result span: 2.
			tabulator transmit
				to: #files;
				andShow: [ :p | 
					p fastTable
						title: 'Files';
						act: [ self loadDirectoryTestFiles ] icon: GLMUIThemeExtraIcons glamorousOpen entitled: 'Parse Directory';
						act: [ self reloadTestFiles ] icon: GLMUIThemeExtraIcons glamorousRefresh entitled: 'Refresh';
						display: [ self testFiles ];
						updateOn: #testFiles from: self;
						column: 'File' evaluated: [ :each | each first basename ] tags: [ :each | Array with: each last ];
						column: 'Directory' evaluated: [ :each | each first parent pathString ] ].
			tabulator transmit
				from: #files port: #selection;
				to: #result;
				transformed: [ :each | 
					each notNil
						ifTrue: [ [ | source |
							each first asFileReference
								readStreamDo: [ :str | 
									self parserClass setEncodingOn: str.
									source := str contents ].
							self parserClass parse: source ]
								on: Error
								do: [ :ex | ex return: ex ] ] ];
				andShow: [ :p :selection | (p custom: GTInspector new) title: 'Inspector' ] ]
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> buildTestTabOn: stacker [
	stacker aPane: #test.
	stacker transmit
		to: #test;
		andShow: [ :presentation | 
			presentation
				title: self testLabel;
				act: [ self parse ] entitled: 'Evaluate';
				act: [ self parseAndInspect ] entitled: 'Inspect...';
				act: [ self debugParse ] entitled: 'Debug...'.
			presentation bloc
				element: [ | element |
					element := self textEditorElementOn: testEditor.
					self addTestShortcutsOn: element.
					element ] ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> changedTabPage: aLazyTabPageChanged [
	self isSourceTabSelected
		ifTrue: [ self definitionSource: self definition ].
	self isAnnotationTabSelected
		ifTrue: [ self saveAnnotatedSource ].
	lastTabPage := aLazyTabPageChanged pageIndex
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> close [
	self isModified
		ifTrue: [ self promptToSaveChanges
				ifFalse: [ ^ self ] ].
	self window close
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> codeGeneratorClass [
	^ SmaCCCodeGenerator withAllSubclasses
		detect: [ :each | each typeName = codeGeneratorType ]
		ifNone: [ SmaCCSmalltalkCodeGenerator new ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> codeGeneratorClasses [
	^ SmaCCCodeGenerator withAllSubclasses select: [ :each | each typeName notNil ]
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> compile [
	self isAnnotationTabSelected
		ifTrue: [ self saveAnnotatedSource ].
	^ self compile: type
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> compile: aSymbol [
	| grammar stream oldCharacterSize parserCompiler messageCollection |
	(self scannerClassName isEmpty or: [ self parserClassName isEmpty ])
		ifTrue: [ ^ UIManager default alert: 'Both classes are not specified' ].
	messageCollection := OrderedCollection new.
	Cursor wait
		showWhile: [ oldCharacterSize := SmaCCGrammar maximumCharacterValue.
			[ SmaCCGrammar
				maximumCharacterValue:
					(allowUnicode
						ifTrue: [ 16rE01EF ]
						ifFalse: [ 255 ]).
			self verifyParser
				ifFalse: [ ^ self ].
			parserCompiler := self compiler.
			parserCompiler
				codeGenerator: self codeGeneratorClass new;
				buildDefinition: self definition;
				scannerClass: self scannerClassName;
				parserClass: self parserClassName.
			grammar := parserCompiler grammar.
			grammar type: aSymbol.
			stream := WriteStream on: String new.
			[ parserCompiler createChanges.
			parserCompiler codeGenerator compileChanges.
			viewSymbols
				ifTrue: [ self symbols: parserCompiler symbolsComment ].
			viewItemSets
				ifTrue: [ self itemSets: parserCompiler itemSetsComment ] ]
				on: SmaCCCompilationNotification
				do: [ :ex | 
					(ShowPrecedenceConflicts or: [ ('*precedence*' match: ex messageText) not ])
						ifTrue: [ messageCollection add: ex messageText , (String with: Character cr with: Character cr) , ex tag ].
					ex pass ].
			messageCollection asSortedCollection
				do: [ :each | 
					stream
						nextPutAll: '-------------------------';
						cr;
						nextPutAll: each;
						cr ].
			self messages: stream contents.
			self messages notEmpty
				ifTrue: [ self switchToMessages ].
			self markAsUnmodified ]
				ensure: [ SmaCCGrammar maximumCharacterValue: oldCharacterSize ] ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> compiler [
	^SmaCCGrammarCompiler new
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> compose [
	| stacker tabulator |
	self title: 'SmaCC'.
	tabulator := self tabulator.
	tabulator
		row: #main;
		row: [ :row | 
			row
				column: #menu size: 25;
				column: #buttons;
				column: #ignore ]
			size: 35.
	tabulator transmit
		to: #main;
		andShow: [ :p | 
			stacker := GLMStacker new.
			p custom: stacker.
			self buildSourceTabOn: stacker.
			self buildAnnotationTabOn: stacker.
			self buildScannerTestTabOn: stacker.
			self buildTestTabOn: stacker.
			self buildTestFilesTabOn: stacker.
			self buildMessagesTabOn: stacker.
			self buildSymbolsTabOn: stacker.
			self buildItemSetsTabOn: stacker ].
	tabulator transmit
		fromOutsidePort: #definitionSource;
		to: #main port: #definitionSource.
	tabulator transmit
		fromOutsidePort: #entity;
		to: #main port: #definitionSource.
	tabulator transmit
		to: #buttons;
		andShow: [ :p | 
			| actionList |
			actionList := p actionList.
			self buildButtonItemsOn: actionList ].
	tabulator transmit
		to: #menu;
		andShow: [ :p | self buildMenuItemsOn: p ]
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> debugParse [
	| process |
	process := [ self parserClass parse: self test asString ] newProcess.
	[ (process suspendedContext receiver isKindOf: SmaCCParser)
		and: [ process suspendedContext selector = #parse ] ]
		whileFalse: [ process step: process suspendedContext ].
	process debug
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> defaultTextAttributes [
	^ {(BrFontSizeAttribute size: 14) beNotOverwritableByStyler.
	BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler}
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> definition [
	^ definitionEditor text asString
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> definition: source [
	| text |
	text := source asRopedText.
	text attributes: self defaultTextAttributes.
	definitionEditor text: text.
	self definitionSource: text
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> definitionAST [
	^ [ SmaCCDefinitionParser parse: self definition ]
		on: Error
		do: [ :ex | ex return: SmaCCGrammarDefinitionNode new ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> definitionItems [
	| items keywords |
	definitionAST := self definitionAST.
	items := OrderedCollection withAll: definitionAST rules.
	keywords := Dictionary new.
	definitionAST allNodesOfType: SmaCCKeywordSymbolNode do: [ :each | keywords at: each name value put: each ].
	items addAll: (keywords values asSortedCollection: [ :a :b | a name value < b name value ]).
	[ definitionAST attributeNamed: #scannerClass put: self scannerClass ]
		on: Error
		do: [ :ex | ex return ].
	^ items
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> definitionSource: aString [
	(self pane port: #definitionSource) value: aString.
	self testFiles: #()
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> displayError: aString at: position [
	self textWidget
		ifNotNil: [ :each | 
			each inserter
				at: position - 1;
				string: aString , '->';
				insert.
			each selecter
				from: position - 1 to: position + aString size + 1;
				select ]
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> endPositionOfNode: aRuleNode [
	| source index comments char |
	source := aRuleNode topParent completeSource.
	index := aRuleNode stopPosition + 1.
	comments := (aRuleNode topParent comments select: [ :each | each first >= index ]) asSortedCollection: [ :a :b | a first < b first ].
	[ comments
		do: [ :each | 
			each first = index
				ifTrue: [ index := each last + 1 ] ].
	index < source size ]
		whileTrue: [ char := source at: index.
			((char = Character cr or: [ char = Character lf ]) or: [ char isSeparator not ])
				ifTrue: [ ^ index - 1 ].
			index := index + 1 ].
	^ source size
]

{ #category : #'actions-source' }
SmaCCParserGeneratorPresentation >> extractSourceIn: anElement [
	| selections selection productionRule ast from to productionExpression itemsToExtract newText source index |
	selections := definitionEditor selection allSelections.
	selections size ~= 1
		ifTrue: [ ^ self ].
	selection := selections first.
	selection isEmpty
		ifTrue: [ ^ self ].
	ast := self definitionAST.
	from := selection from + 1.
	to := selection to.
	productionRule := self productionRuleFor: from in: ast.
	productionRule isNil
		ifTrue: [ ^ self ].
	productionRule == (self productionRuleFor: to in: ast)
		ifFalse: [ ^ self ].
	productionExpression := self productionExpressionIn: productionRule from: from to: to.
	productionExpression isNil
		ifTrue: [ ^ self ].
	itemsToExtract := productionExpression terms reject: [ :each | to < each startPosition or: [ from > each stopPosition ] ].
	newText := SmaCCString on: ast completeSource.
	newText insert: '_' at: itemsToExtract first startPosition.
	newText insert: (newText whitespaceBeforeIndex: productionRule semicolon startPosition) , ';' at: productionRule stopPosition + 1.
	newText moveFrom: itemsToExtract first startPosition to: itemsToExtract last stopPosition after: productionRule stopPosition.
	newText insert: (newText whitespaceBeforeIndex: productionRule startPosition) , '_ : ' at: (newText nextIndex: productionRule stopPosition).
	source := newText asString.
	self definition: source.
	definitionEditor deselecter all deselect.
	definitionEditor moveCursorTo: itemsToExtract first startPosition.
	index := source indexOf: $_ startingAt: itemsToExtract first startPosition + 1.
	(GtRenameAction
		locations:
			{(itemsToExtract first startPosition to: itemsToExtract first startPosition).
			(index to: index)}
		element: anElement) install
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> findParserClass [
	| class subclasses |
	self isModified
		ifTrue: [ self promptToSaveChanges
				ifFalse: [ ^ self ] ].
	subclasses := (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]) asArray.
	class := UIManager default
		chooseFrom: (subclasses collect: [ :each | each name ])
		values: subclasses
		message: 'What class do you want to use?'.
	class isNil
		ifTrue: [ ^ self ].
	self parserClassName: class name.
	self updateDefinitionFor: class.
	self markAsUnmodified
]

{ #category : #'actions-source' }
SmaCCParserGeneratorPresentation >> gotoDefinitionIn: anElement [
	| node definition |
	node := self nodeAtCursor.
	(node isKindOf: SmaCCSymbolNode)
		ifFalse: [ ^ self ].
	definition := node definition.
	definition isNil
		ifTrue: [ ^ self ].
	self scrollToPosition: definition startPosition in: anElement
]

{ #category : #'initialize-release' }
SmaCCParserGeneratorPresentation >> initialize [
	super initialize.
	savedDefinition := ''.
	allowUnicode := false.
	type := #LALR1.
	codeGeneratorType := #Smalltalk.
	viewSymbols := true.
	viewItemSets := false.
	definitionEditor := BrTextEditor new.
	messagesEditor := BrTextEditor new.
	symbolsEditor := BrTextEditor new.
	itemSetsEditor := BrTextEditor new.
	testEditor := BrTextEditor new.
	lastTabPage := 1.
	testFiles := #()
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> inlineAllReferencesTo: aProductionRuleNode [
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> inlineDefinition: aProductionSymbolNode [
	| rule inlineSource |
	aProductionSymbolNode variableNameToken notNil
		ifTrue: [ ^ self inform: 'Cannot inline symbol when it has a variable name' ].
	rule := aProductionSymbolNode lookupRule: aProductionSymbolNode name value.
	rule isNil
		ifTrue: [ ^ self inform: 'Cannot find definition' ].
	(rule expressions allSatisfy: [ :each | each class = SmaCCProductionExpressionNode ])
		ifFalse: [ ^ self inform: 'Cannot inline definition when it defines an AST node or has a code expression' ].
	inlineSource := self inlinedDefinitionOf: rule.
	definitionEditor deleter
		from: aProductionSymbolNode startPosition - 1 to: aProductionSymbolNode stopPosition;
		delete.
	definitionEditor inserter
		at: aProductionSymbolNode startPosition - 1;
		string: inlineSource;
		insert
]

{ #category : #'actions-source' }
SmaCCParserGeneratorPresentation >> inlineSource [
	| node |
	node := self nodeAtCursor.
	node isNil
		ifTrue: [ ^ self ].
	(node isKindOf: SmaCCProductionSymbolNode)
		ifTrue: [ self inlineDefinition: node ].
	((node isKindOf: SmaCCProductionRuleNode) and: [ self sourceCursorPosition between: node name startPosition and: node name stopPosition ])
		ifTrue: [ self inlineAllReferencesTo: node ]
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> inlinedDefinitionOf: rule [
	| firstIsEmpty expression |
	(rule expressions size = 2
		and: [ (firstIsEmpty := rule expressions first isEmptyExpression) or: [ rule expressions last isEmptyExpression ] ])
		ifTrue: [ expression := firstIsEmpty
				ifTrue: [ rule expressions last ]
				ifFalse: [ rule expressions first ].
			^ expression terms size = 1
				ifTrue: [ expression source , '?' ]
				ifFalse: [ '( ' , expression source , ' )?' ] ].
	^ String
		streamContents: [ :stream | 
			| nonEmptyRules |
			nonEmptyRules := rule expressions reject: [ :each | each isEmptyExpression ].
			rule expressions size > 1
				ifTrue: [ stream nextPutAll: '( ' ].
			nonEmptyRules do: [ :each | stream nextPutAll: each source ] separatedBy: [ stream nextPutAll: ' | ' ].
			rule expressions size > 1
				ifTrue: [ stream nextPutAll: ' )' ].
			nonEmptyRules size ~= rule expressions size
				ifTrue: [ stream nextPut: $? ] ]
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isAnnotationTabSelected [
	^ (self pageLabel: lastTabPage) = self annotationsLabel
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isLALR1 [
	^ type = #LALR1
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isLR1 [
	^ type = #LR1
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isModified [
	^ savedDefinition ~= self definition
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isSourceTabSelected [
	^ (self pageLabel: lastTabPage) = self sourceLabel
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isUnicode [
	^ allowUnicode
]

{ #category : #testing }
SmaCCParserGeneratorPresentation >> isValidName: aString [
	^ aString first isUppercase and: [ RBScanner isVariable: aString ]
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> itemSets [
	^ itemSetsEditor text asString
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> itemSets: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	itemSetsEditor text: text
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> itemSetsLabel [
	^ 'Item Sets'
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> language [
	^ codeGeneratorType
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> loadDirectoryTestFiles [
	| directory |
	directory := UITheme builder chooseDirectory: 'Parse files in directory' path: nil.
	directory isNil
		ifTrue: [ ^ self ].
	testFileDirectory := directory.
	self reloadTestFiles
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> markAsUnmodified [
	savedDefinition := self definition
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> messages [
	^ messagesEditor text asString
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> messages: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	messagesEditor text: text
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> messagesLabel [
	^ 'Messages'
]

{ #category : #'actions-source' }
SmaCCParserGeneratorPresentation >> moveDefinitionDown [
	| definition topParent node index |
	node := self nodeAtCursor.
	node isNil
		ifTrue: [ ^ self ].
	topParent := node topParent.
	definition := node lookupNode: [ :each | each parent == topParent ].
	index := topParent rules identityIndexOf: definition.
	index < topParent rules size
		ifFalse: [ ^ self ].
	self swapRulesAt: index withNextIn: topParent
]

{ #category : #'actions-source' }
SmaCCParserGeneratorPresentation >> moveDefinitionUp [
	| definition topParent node index |
	node := self nodeAtCursor.
	node isNil
		ifTrue: [ ^ self ].
	topParent := node topParent.
	definition := node lookupNode: [ :each | each parent == topParent ].
	index := topParent rules identityIndexOf: definition.
	index > 1
		ifFalse: [ ^ self ].
	self swapRulesAt: index - 1 withNextIn: topParent
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> nodeAtCursor [
	| position text ast innerNode |
	position := self sourceCursorPosition.
	position isNil
		ifTrue: [ ^ nil ].
	text := self definition.
	ast := self definitionAST.
	ast
		withAllNodesDo: [ :each | 
			(position between: each startPosition and: each stopPosition)
				ifTrue: [ innerNode := each ] ].
	^ innerNode
]

{ #category : #'scripting opening' }
SmaCCParserGeneratorPresentation >> openWith: aRenderer [
	| window |
	window := super openWith: aRenderer.
	"really ugly, but I don't see any other way to allow me to switch tabs"
	tabGroup := window submorphs last submorphs first submorphs first.
	tabGroup announcer when: LazyTabPageChanged do: [ :event | self changedTabPage: event ].
	^ window
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> pageLabel: anIndex [
	^ (tabGroup pageMorphs at: anIndex) labelMorph
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> parse [
	self parseAndEvaluate: [ :each | UIManager default message: 'Parses without errors' ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> parseAndEvaluate: aBlock [
	| class |
	class := self parserClass.
	class isNil
		ifTrue: [ ^ UIManager default alert: 'No parser defined' ].
	aBlock
		value:
			(class
				parse: self test asString
				onError: [ :aString :position | 
					self switchToPage: 'Test'.
					self displayError: aString at: position.
					^ self ])
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> parseAndInspect [
	self parseAndEvaluate: [ :each | each inspect ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> parserClass [
	self parserClassName isEmpty
		ifTrue: [ ^ nil ].
	^ Smalltalk at: self parserClassName asSymbol
]

{ #category : #accessing }
SmaCCParserGeneratorPresentation >> parserClassName [
	^ parserClassName
]

{ #category : #accessing }
SmaCCParserGeneratorPresentation >> parserClassName: aString [
	parserClassName := aString
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> productionExpressionIn: productionRule from: from to: to [
	| expressions |
	expressions := productionRule expressions.
	expressions isEmpty
		ifTrue: [ ^ nil ].
	expressions size = 1
		ifTrue: [ ^ expressions first ].
	productionRule barTokens
		keysAndValuesDo: [ :i :each | 
			to < each startPosition
				ifTrue: [ ^ expressions at: i ].
			from <= each startPosition
				ifTrue: [ ^ nil ] ].
	^ expressions last
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> productionRuleFor: anIndex in: anAST [
	^ anAST productionRules detect: [ :each | anIndex between: each startPosition and: each stopPosition ] ifNone: [ nil ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> promptToSaveChanges [
	^ (self confirm: 'The definition has been modified. Do you wish to retain your changes?') not
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> reloadTestFiles [
	| filenames fileResults class |
	testFileDirectory isNil
		ifTrue: [ ^ self ].
	class := self parserClass.
	class isNil
		ifTrue: [ ^ self ].
	(class fileExtensions anySatisfy: [ :each | each isEmpty ])
		ifTrue: [ ^ self ].
	filenames := class sourceFilesIn: testFileDirectory.
	fileResults := OrderedCollection new: filenames size.
	filenames
		do: [ :each | 
			| hasError |
			hasError := false.
			[ class parseFile: each ]
				on: Error
				do: [ :ex | 
					hasError := true.
					ex return ].
			fileResults
				add:
					(Array
						with: each
						with:
							(hasError
								ifTrue: [ 'Error' ]
								ifFalse: [ 'OK' ])) ]
		displayingProgress: 'Parsing files'.
	self testFiles: fileResults
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> renameSymbolOn: aTextElement [
	[ | editor text ast items action position |
	editor := aTextElement editor.
	editor cursor cursorsCount ~= 1
		ifTrue: [ ^ self ].
	position := editor cursor first position.
	text := editor text.
	ast := SmaCCDefinitionParser parseWithErrors: text asString.
	items := ast findItemsToRenameFrom: position.
	action := GtRenameAction locations: items element: aTextElement.
	action install ]
		on: Error
		do: [ :ex | ex return ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> saveAnnotatedSource [
	| string source newSource |
	source := definitionAST completeSource.
	source isNil
		ifTrue: [ ^ self ].
	string := SmaCCString on: source.
	definitionAST allNodesDo: [ :node | node updateSource: string ].
	newSource := string asString.
	self definition = newSource
		ifFalse: [ self definition: newSource ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> savedDefinition: aString [
	savedDefinition := aString.
	self definition: aString
]

{ #category : #accessing }
SmaCCParserGeneratorPresentation >> scannerClassName [
	^ scannerClassName
]

{ #category : #accessing }
SmaCCParserGeneratorPresentation >> scannerClassName: aString [
	scannerClassName := aString
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> scannerTestLabel [
	^ 'Scanner Test'
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> scrollToPosition: anInteger [
	| stream line |
	stream := SmaCCLineNumberStream on: self definition readStream.
	stream position: anInteger.
	stream lineNumber
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> scrollToPosition: anInteger in: element [
	| stream |
	stream := SmaCCLineNumberStream on: self definition readStream.
	stream position: anInteger.
	element scrollToPosition: stream lineNumber.
	element editor moveCursorTo: anInteger - 1
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> setCodeGenerator: aSymbol [
	codeGeneratorType := aSymbol
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> setLALR1 [
	type := #LALR1
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> setLR1 [
	type := #LR1
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> setParserClass [
	| name |
	name := UIManager default request: 'Enter parser class name:' initialAnswer: self parserClassName.
	(name isNil or: [ name isEmpty ])
		ifTrue: [ ^ self ].
	(self isValidName: name)
		ifFalse: [ ^ UIManager default inform: 'Invalid Class Name' ].
	self parserClassName: name asSymbol
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> setScannerClass [
	| name |
	name := UIManager default request: 'Enter scanner class name:' initialAnswer: self scannerClassName.
	(name isNil or: [ name isEmpty ])
		ifTrue: [ ^ self ].
	(self isValidName: name)
		ifFalse: [ ^ UIManager default inform: 'Invalid Class Name' ].
	self scannerClassName: name asSymbol
]

{ #category : #'private-scanner' }
SmaCCParserGeneratorPresentation >> simulateUsing: simulator tokenEditor: editor testEditor: testerEditor index: anIndex [
	editor text clearAttributes: [ :each | each isKindOf: BrTextBackgroundAttribute ].
	testerEditor text clearAttributes: [ :each | each isKindOf: BrTextBackgroundAttribute ].
	simulator
		matchesOn: testerEditor text asString
		do: [ :index :nodes | 
			nodes isNil
				ifTrue: [ (testerEditor text from: index to: testerEditor text size) background: Color lightRed ]
				ifFalse: [ (index = anIndex and: [ nodes notEmpty ])
						ifTrue: [ | children start |
							start := (nodes asArray first nodeOfType: SmaCCTokenRuleNode) startPosition - 1.
							nodes
								do: [ :each | each testTokensDo: [ :token | (editor text from: token startPosition - start to: token stopPosition - start) background: Color green ] ] ] ] ].
	editor text: editor text.
	testerEditor text: testerEditor text
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> sourceCursorPosition [
	definitionEditor cursor cursorsCount = 1
		ifFalse: [ ^ nil ].
	^ definitionEditor cursor first position
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> sourceLabel [
	^ 'Source'
]

{ #category : #'private-source' }
SmaCCParserGeneratorPresentation >> swapRulesAt: anIndex withNextIn: ast [
	| startIndex endIndex newPosition source cursorPosition firstNode lastNode |
	firstNode := ast rules at: anIndex.
	lastNode := ast rules at: anIndex + 1.
	startIndex := (self endPositionOfNode: firstNode) + 1.
	endIndex := self endPositionOfNode: lastNode.
	source := ast completeSource asString.
	newPosition := anIndex > 1
		ifTrue: [ (self endPositionOfNode: (ast rules at: anIndex - 1)) + 1 ]
		ifFalse: [ 1 ].
	self
		definition:
			(source copyFrom: 1 to: newPosition - 1) , (source copyFrom: startIndex to: endIndex) , (source copyFrom: newPosition to: startIndex - 1)
				, (source copyFrom: endIndex + 1 to: source size).
	cursorPosition := definitionEditor cursor first position.
	(cursorPosition between: firstNode startPosition and: firstNode stopPosition)
		ifTrue: [ definitionEditor moveCursorTo: definitionEditor cursor first position + endIndex - startIndex + 1 ].
	(cursorPosition between: lastNode startPosition and: lastNode stopPosition)
		ifTrue: [ definitionEditor moveCursorTo: definitionEditor cursor first position - startIndex + newPosition ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> switchToMessages [
	self switchToPage: self messagesLabel
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> switchToPage: aString [
	tabGroup pageMorphs
		keysAndValuesDo: [ :i :each | 
			each labelMorph = aString
				ifTrue: [ tabGroup selectedPageIndex: i ] ]
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> switchToSource [
	self switchToPage: self sourceLabel
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> symbols [
	^ symbolsEditor text asString
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> symbols: aString [
	| text |
	text := aString asRopedText.
	text attributes: self defaultTextAttributes.
	symbolsEditor text: text
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> symbolsLabel [
	^ 'Symbols'
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> test [
	^ testEditor text asString
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> testFiles [
	^ testFiles
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> testFiles: aCollection [
	testFiles := aCollection.
	self announce: #testFiles
]

{ #category : #'private-accessing' }
SmaCCParserGeneratorPresentation >> testLabel [
	^ 'Test'
]

{ #category : #building }
SmaCCParserGeneratorPresentation >> textEditorElementOn: aTextEditor [
	| editorElement |
	editorElement := BrEditorElement new.
	editorElement editor: aTextEditor.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ editorElement
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> textWidget [
	| label |
	label := (tabGroup pageMorphs at: tabGroup selectedPageIndex) labelMorph.
	label = self sourceLabel
		ifTrue: [ ^ definitionEditor ].
	label = self testLabel
		ifTrue: [ ^ testEditor ].
	^ nil
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> type [
	^ type
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> updateDefinitionFor: parserClass [
	| scannerClass |
	scannerClass := [ parserClass scannerClass ]
		on: Error
		do: [ :ex | ex return: nil ].
	scannerClass notNil
		ifTrue: [ self scannerClassName: scannerClass name ].
	self savedDefinition: parserClass definitionString.
	self messages: ''.
	self symbols: ''.
	self itemSets: ''.
	self switchToSource
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> useUnicode [
	allowUnicode := allowUnicode not
]

{ #category : #private }
SmaCCParserGeneratorPresentation >> verifyParser [
	^ [ SmaCCGrammarCompiler new
		codeGenerator: self codeGeneratorClass new;
		buildDefinition: self definition.
	true ]
		on: SmaCCParserError
		do:
			[ :ex | 
			self switchToSource.
			self displayError: ex description at: ex tag position.
			ex return: false ]
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> viewItemSetsClicked [
	viewItemSets := viewItemSets not
]

{ #category : #actions }
SmaCCParserGeneratorPresentation >> viewSymbolsClicked [
	viewSymbols := viewSymbols not
]
