Class {
	#name : #GtSmaCCCompilationIssues,
	#superclass : #Object,
	#instVars : [
		'issues',
		'grammar',
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-Issues'
}

{ #category : #accessing }
GtSmaCCCompilationIssues >> ambiguousActionFilters [
	| filters |
	filters := OrderedCollection new.
	self ambiguousActions
		do: [ :each | 
			| filter |
			filter := GtSmaCCAmbiguousFilter from: each.
			(1 to: filters size)
				detect: [ :i | filter canBeMergedWith: (filters at: i) ]
				ifFound: [ :i | 
					filters
						at: i
						put: (GtSmaCCAmbiguousFilter
								merged: {filter.
										filters at: i}) ]
				ifNone: [ filters add: filter ] ].
	^ filters
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> ambiguousActionHandledByPrecedenceFilters [
	| filters |
	filters := OrderedCollection new.
	self ambiguousActionsHandledByPrecedence
		do: [ :each | 
			| filter |
			filter := GtSmaCCAmbiguousFilter from: each.
			(1 to: filters size)
				detect: [ :i | filter canBeMergedWith: (filters at: i) ]
				ifFound: [ :i | 
					filters
						at: i
						put: (GtSmaCCAmbiguousFilter
								merged: {filter.
										filters at: i}) ]
				ifNone: [ filters add: filter ] ].
	^ filters
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> ambiguousActions [
	^ self issues at: SmaCCAmbiguousActionIssue ifAbsent: [ #() ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> ambiguousActionsHandledByPrecedence [
	^ self issues
		at: SmaCCAmbiguousActionHandledByPrecedenceIssue
		ifAbsent: [ #() ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> grammar [
	^ grammar
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> grammar: anObject [
	grammar := anObject
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> grammarCoder [
	^ grammarCoder
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> grammarCoder: anObject [
	grammarCoder := anObject
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtAmbiguousActionsFor: aView [
	<gtView>
	(grammarCoder isNil or: [ self ambiguousActions isEmpty ])
		ifTrue: [ ^ aView empty ].
	^ aView tree
		title: 'Amibiguous actions';
		priority: 25;
		items: [ | map |
			map := Dictionary new.
			self ambiguousActionFilters
				do: [ :each | 
					each reductionNames
						do: [ :name | 
							each lookaheads
								do: [ :sym | 
									((map at: name ifAbsentPut: [ Dictionary new ])
										at: sym
										ifAbsentPut: [ OrderedCollection new ]) add: each ] ] ].
			map keys asSortedCollection
				collect: [ :name | 
					{name.
						(map at: name) keys asSortedCollection
							collect: [ :sym | 
								{sym.
									(((map at: name) at: sym)
										asSortedCollection: [ :a :b | a count > b count ])
										collect: [ :filter | 
											{' ' join: filter path.
												#().
												filter} ].
									((map at: name) at: sym) anyOne} ].
						(map at: name) anyOne anyOne} ] ];
		children: [ :each | each second ];
		itemText: [ :each | each first asRopedText ];
		send: [ :each | (GtSmaCCGrammarFilter on: grammarCoder) & each third ]
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtAmbiguousActionsHandledByPrecedenceFor: aView [
	<gtView>
	(grammarCoder isNil or: [ self ambiguousActionsHandledByPrecedence isEmpty ])
		ifTrue: [ ^ aView empty ].
	^ aView tree
		title: 'Amibiguous actions handled by precedence';
		priority: 35;
		items: [ | map |
			map := Dictionary new.
			self ambiguousActionHandledByPrecedenceFilters
				do: [ :each | 
					each reductionNames
						do: [ :name | 
							each lookaheads
								do: [ :sym | 
									((map at: name ifAbsentPut: [ Dictionary new ])
										at: sym
										ifAbsentPut: [ OrderedCollection new ]) add: each ] ] ].
			map keys asSortedCollection
				collect: [ :name | 
					{name.
						(map at: name) keys asSortedCollection
							collect: [ :sym | 
								{sym.
									(((map at: name) at: sym)
										asSortedCollection: [ :a :b | a count > b count ])
										collect: [ :filter | 
											{' ' join: filter path.
												#().
												filter} ].
									((map at: name) at: sym) anyOne} ].
						(map at: name) anyOne anyOne} ] ];
		children: [ :each | each second ];
		itemText: [ :each | each first asRopedText ];
		send: [ :each | (GtSmaCCGrammarFilter on: grammarCoder) & each third ]
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtMissingSymbolsFor: aView [
	<gtView>
	| items |
	items := self missingSymbols.
	(grammarCoder isNil or: [ items isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Missing symbols';
		priority: 5;
		object: [ (GtSmaCCGrammarFilter on: grammarCoder)
				& ((items collect: [ :each | GtSmaCCDefinitionReferencesFilter name: each ])
						reduce: [ :a :b | a | b ]) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtNodeCreationFor: aView [
	<gtView>
	| items |
	items := self nodeCreation collect: #name.
	(grammarCoder isNil or: [ items isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Node creation';
		priority: 10;
		object: [ (GtSmaCCGrammarFilter on: grammarCoder)
				& (GtSmaCCNameDefinitionFilter new names: items) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtProductionShouldReturnNodeFor: aView [
	<gtView>
	| items |
	items := self productionsShouldReturnNodes.
	(grammarCoder isNil or: [ items isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Production should be nodes';
		priority: 11;
		object: [ (GtSmaCCGrammarFilter on: grammarCoder)
				& (GtSmaCCNameDefinitionFilter new names: items) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtUnusedSymbolsFor: aView [
	<gtView>
	| items |
	items := self unusedSymbols.
	(grammarCoder isNil or: [ items isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Unused symbols';
		priority: 30;
		object: [ (GtSmaCCGrammarFilter on: grammarCoder)
				& (GtSmaCCNameDefinitionFilter new names: items) ];
		view: #gtItemsFor:
]

{ #category : #views }
GtSmaCCCompilationIssues >> gtValueIsNotUsedFor: aView [
	<gtView>
	| items |
	items := self valuesDroppedFromAst.
	items isEmpty ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Unused values';
		priority: 20;
		stencil: [ | element names |
			names := items flatCollectAsSet: [ :each | each itemNames ].
			element := (GtSmaCCGrammarCoder onGrammar: grammar) asVariableElement.
			element defaultFilter: (GtSmaCCVariablesFilter new names: names).
			element showOnlyUnnamed: true.
			element ]
]

{ #category : #testing }
GtSmaCCCompilationIssues >> hasIssues [
	^ self issues notEmpty
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> issues [
	^ issues ifNil: [ issues := Dictionary new ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> issues: aCollection [
	issues := aCollection groupedBy: #class
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> missingSymbols [
	^ (self issues at: SmaCCMissingSymbolsIssue ifAbsent: [ #() ])
		flatCollectAsSet: [ :each | each missing collect: #name ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> nodeCreation [
	^ (self issues at: SmaCCNodeCreationIssue ifAbsent: [ #() ])
		collectAsSet: [ :each | each reduction rhs productionSymbol ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> productionsShouldReturnNodes [
	^ (self issues at: SmaCCNonTerminalShouldBeNode ifAbsent: [ #() ])
		collectAsSet: [ :each | (each rhs at: each problemIndex) name ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> unusedSymbols [
	^ (self issues at: SmaCCUnusedSymbolsIssue ifAbsent: [ #() ])
		flatCollectAsSet: [ :each | each unused collect: #name ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> valuesDroppedFromAst [
	^ self issues at: SmaCCValueIsDroppedIssue ifAbsent: [ #() ]
]
