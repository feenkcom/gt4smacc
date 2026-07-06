Class {
	#name : #GtIncrementalParserFullUpdateAstComparison,
	#superclass : #Object,
	#instVars : [
		'updatedAst',
		'rootComparison',
		'previousAst'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #'instance creation' }
GtIncrementalParserFullUpdateAstComparison class >> from: anInitialAst to: anUpdatedAst [
	^ self new
		previousAst: anInitialAst;
		updatedAst: anUpdatedAst;
		buildComparison;
		yourself
]

{ #category : #building }
GtIncrementalParserFullUpdateAstComparison >> buildComparison [
	rootComparison := self comparisonFor: updatedAst against: previousAst
]

{ #category : #building }
GtIncrementalParserFullUpdateAstComparison >> comparisonFor: aNewAstNode against: aPreviousAstNode [
	| allPreviousChildrenById |
	allPreviousChildrenById := Dictionary new.
	
	aPreviousAstNode ifNotNil: [
		aPreviousAstNode withAllNodesDo: [ :each |
			(each isKindOf: SmaCCParseNode) ifTrue: [ 
				allPreviousChildrenById at: each id put: each ] ] ].
			
	^ self 
		comparisonFor: aNewAstNode 
		against: aPreviousAstNode 
		previousNodes: allPreviousChildrenById 
]

{ #category : #building }
GtIncrementalParserFullUpdateAstComparison >> comparisonFor: aNewAstNode against: aPreviousAstNode previousNodes: allPreviousChildrenById [ 
	| children |
			
	children := aNewAstNode children
		select: [ :each | each isKindOf: SmaCCParseNode ]
		thenCollect: [ :each |
			self
				comparisonFor: each
				against: (allPreviousChildrenById at: each id ifAbsent: [ nil ])
				previousNodes: allPreviousChildrenById  ].
				
	^ GtIncrementalParserAstNodeComparison new
		newAstNode: aNewAstNode;
		oldAstNode: ((aPreviousAstNode notNil and: [ aNewAstNode id = aPreviousAstNode id ]) ifTrue: [ aPreviousAstNode ] ifFalse: [ nil ]);
		isReused: (aPreviousAstNode notNil and: [ aNewAstNode id = aPreviousAstNode id ]);
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
	^ (rootComparison gtTreeFor: aView)
			expandUpTo: 2
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
					computeDifferencesFrom: (previousAst completeSource asString 
						copyWithoutAll: {(Character value: 9608)})
					to: (updatedAst completeSource asString )
					using: GtSmaCCDiffSplitter forPharo);
				styler: GtCodeDiffRBTextStyler new	]
]

{ #category : #'gt views' }
GtIncrementalParserFullUpdateAstComparison >> gtViewPreviousTreeFor: aView [
	<gtView>
	^ (self previousAst gtTreeFor: aView)
			title: 'Previous AST';
			priority: 40;
			column: 'Node Id' text: [ :each  | 
				(each value at: 2) = #node	
					ifTrue: [ each last id ]
					ifFalse: [ '' ] ];
			expandUpTo: 2
]

{ #category : #'gt views' }
GtIncrementalParserFullUpdateAstComparison >> gtViewUpdatedTreeFor: aView [
	<gtView>
	^ (self updatedAst gtTreeFor: aView)
			title: 'Updated AST';
			priority: 41;
			column: 'Node Id' text: [ :each  | 
				(each value at: 2) = #node	
					ifTrue: [ each last id ]
					ifFalse: [ '' ] ];
			expandUpTo: 2
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> previousAst [
	^ previousAst
]

{ #category : #accessing }
GtIncrementalParserFullUpdateAstComparison >> previousAst: anAst [
	previousAst := anAst
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
