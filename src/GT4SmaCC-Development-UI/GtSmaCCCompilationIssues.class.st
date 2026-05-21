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
GtSmaCCCompilationIssues >> gtMissingSymbolsFor: aView [
	<gtView>
	| items |
	items := self missingSymbols.
	(grammarCoder isNil or: [ items isEmpty ]) ifTrue: [ ^ aView empty ].
	^ aView forward
		title: 'Missing symbols';
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

{ #category : #'as yet unclassified' }
GtSmaCCCompilationIssues >> missingSymbols [
	^ (self issues at: SmaCCMissingSymbolsIssue ifAbsent: [ #() ])
		flatCollectAsSet: [ :each | each missing collect: #name ]
]

{ #category : #'as yet unclassified' }
GtSmaCCCompilationIssues >> nodeCreation [
	^ (self issues at: SmaCCNodeCreationIssue ifAbsent: [ #() ])
		collectAsSet: [ :each | each reduction rhs productionSymbol ]
]

{ #category : #'as yet unclassified' }
GtSmaCCCompilationIssues >> productionsShouldReturnNodes [
	^ (self issues at: SmaCCNonTerminalShouldBeNode ifAbsent: [ #() ])
		collectAsSet: [ :each | (each rhs at: each problemIndex) name ]
]

{ #category : #'as yet unclassified' }
GtSmaCCCompilationIssues >> unusedSymbols [
	^ (self issues at: SmaCCUnusedSymbolsIssue ifAbsent: [ #() ])
		flatCollectAsSet: [ :each | each unused collect: #name ]
]

{ #category : #accessing }
GtSmaCCCompilationIssues >> valuesDroppedFromAst [
	^ self issues at: SmaCCValueIsDroppedIssue ifAbsent: [ #() ]
]
