Class {
	#name : #GtIncrementalParserFullUpdateAstComparison,
	#superclass : #Object,
	#instVars : [
		'initialAst',
		'updatedAst',
		'rootComparison'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #'instance creation' }
GtIncrementalParserFullUpdateAstComparison class >> from: anInitialAst to: anUpdatedAst [
	^ self new
		initialAst: anInitialAst;
		updatedAst: anUpdatedAst;
		buildComparison;
		yourself
]

{ #category : #building }
GtIncrementalParserFullUpdateAstComparison >> buildComparison [
	rootComparison := self comparisonFor: updatedAst against: initialAst
]

{ #category : #building }
GtIncrementalParserFullUpdateAstComparison >> comparisonFor: aNewAstNode against: anOldAstNode [
	| children oldChildrenById |
	oldChildrenById := Dictionary new.
	anOldAstNode ifNotNil: [
		anOldAstNode children do: [ :each |
			(each isKindOf: SmaCCParseNode) ifTrue: [ oldChildrenById at: each id put: each ] ] ].
	children := aNewAstNode children
		select: [ :each | each isKindOf: SmaCCParseNode ]
		thenCollect: [ :each |
			self
				comparisonFor: each
				against: (oldChildrenById at: each id ifAbsent: [ nil ]) ].
	^ GtIncrementalParserAstNodeComparison new
		newAstNode: aNewAstNode;
		oldAstNode: ((anOldAstNode notNil and: [ aNewAstNode id = anOldAstNode id ]) ifTrue: [ anOldAstNode ] ifFalse: [ nil ]);
		isReused: (anOldAstNode notNil and: [ aNewAstNode id = anOldAstNode id ]);
		children: children;
		yourself
]

{ #category : #'gt views' }
GtIncrementalParserFullUpdateAstComparison >> gtExploreFor: aView [
	<gtView>
	^ rootComparison ifNil: [ aView empty ] ifNotNil: [ rootComparison gtExploreFor: aView ]
]

{ #category : #'gt views' }
GtIncrementalParserFullUpdateAstComparison >> gtTreeFor: aView [
	<gtView>
	^ rootComparison gtTreeFor: aView
]

{ #category : #'gt views' }
GtIncrementalParserFullUpdateAstComparison >> gtViewCodeDiffFor: aView [
	<gtView>
	
	^ aView explicit
		title: 'Code Diff';
		priority: 1;
		stencil: [
			GtDiffElementWithLabelStencil new
				fromLabelText: 'Initial Source:';
				toLabelText: 'Modified Source: ';
				change: (GtDiffBuilder
					computeDifferencesFrom: (initialAst completeSource asString 
						copyWithoutAll: {(Character value: 9608)})
					to: (updatedAst completeSource asString )
					using: GtSmaCCDiffSplitter forPharo);
				styler: GtCodeDiffRBTextStyler new	]
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> initialAst [
	^ initialAst
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> initialAst: anAst [
	initialAst := anAst
]

{ #category : #printing }
GtIncrementalParserFullUpdateAstComparison >> printOn: aStream [
	aStream
		nextPutAll: 'Incremental AST comparison (';
		print: rootComparison;
		nextPut: $)
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> rootComparison [
	^ rootComparison
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> updatedAst [
	^ updatedAst
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> updatedAst: anAst [
	updatedAst := anAst
]
