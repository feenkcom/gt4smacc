Class {
	#name : #GtIncrementalParserAstNodeComparison,
	#superclass : #Object,
	#instVars : [
		'newAstNode',
		'oldAstNode',
		'children',
		'isReused'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> allParents [
	^ newAstNode allParents collect: [ :each | each == newAstNode ifTrue: [ self ] ifFalse: [ nil ] ] thenSelect: #notNil
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> children [
	^ children ifNil: [ #() ]
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> children: aCollection [
	children := aCollection
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> completeSource [
	^ newAstNode completeSource
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtChildrenOf: each [
	^ (each at: 2) = #node
		ifTrue: [ each last gtInspectorItems ]
		ifFalse: [ (each at: 2) = #nodes
				ifTrue: [ self gtCollectionItems: each last type: #node ]
				ifFalse: [ (each at: 2) = #tokens
						ifTrue: [ self gtCollectionItems: each last type: #token ]
						ifFalse: [ #() ] ] ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtCollectionItems: aCollection type: aSymbol [
	^ (1 to: aCollection size) collect: [ :i | Array with: i printString with: aSymbol with: (aCollection at: i) ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtExploreFor: aView [
	<gtView>
	| topParent |
	topParent := self topParent.
	topParent completeSource isNil ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 5;
		title: 'Explore';
		stencil: [ | element editor tree allParents treeElement |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
			element constraintsDo: [ :c |
				c vertical matchParent.
				c horizontal matchParent ].
			editor := newAstNode gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor.
			editor
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ];
				beReadOnlyWithSelection;
				addAptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: editor.
			treeElement := (self gtTreeFor: GtPhlowView empty) asElementDo: [ :e | e ].
			tree := treeElement children last.
			treeElement
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ];
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: treeElement.
			self gtHookEditor: editor toTree: tree.
			allParents := OrderedCollection with: self.
			tree
				expandSuchThat: [ :each | 
					(allParents includes: each value last)
						or: [ each value second = #nodes
								and: [ allParents anySatisfy: [ :e | each value last includes: e ] ] ] ].
			tree viewModel root
				allChildrenNodesDepthFirstDo: [ :each | each value last = self ifTrue: [ 
					tree selectAndScrollTo: each value ] ].
			element ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtHookEditor: anEditor toTree: aTree [
	| highlightAttribute |
	highlightAttribute := BlTextDecorationAttribute new underline
			beNotOverwritableByStyler;
			color: BrGlamorousColors textHighlightColor;
			thickness: 3.
	aTree
		when: BrSelectionChanged
		do: [ :anEvent |
			aTree selectedNodeDo: [ :aNode |
				| item text |
				item := aNode value last newAstNode.
				text := anEditor editor text.
				text clearAttributes: [ :attr | attr == highlightAttribute ].
				text
					attributes: {highlightAttribute}
					from: (item startPosition min: text size)
					to: (item stopPosition min: text size).
				self gtScrollToPosition: item startPosition inEditor: anEditor ] ].
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do: [ :event |
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ self gtSelectItemIn: aTree at: position ] ]
]

{ #category : #inspecting }
GtIncrementalParserAstNodeComparison >> gtInspectorItems [
	| items |
	items := newAstNode gtInspectorItems.
	^ items
		withIndexCollect: [ :each :anIndex | 
			| actualNodes |
			actualNodes := ((each second = #tokens) or: [each second = #token])
					ifTrue: [ each third ]
					ifFalse: [ each third isCollection
							ifTrue: [ each third
									collect: [ :anAstNode | 
										children
											detect: [ :aComparison | aComparison newAstNode = anAstNode ]
											ifNone: [ nil ] ] ]
							ifFalse: [ children
									detect: [ :aComparison | aComparison newAstNode = each third ]
									ifNone: [ nil ] ] ].
			{each first.
				each second.
				actualNodes} ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtIsPosition: position inComparison: aComparison [
	^ position >= aComparison startPosition and: [ position <= aComparison stopPosition ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtScrollToPosition: aPosition inEditor: anEditor [
	^ newAstNode gtScrollToPosition: aPosition inEditor: anEditor
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtSelectItemIn: aTree at: position [
	| treeNode nextNode |
	aTree collapseAll.
	nextNode := aTree viewModel itemAt: 1.
	[ nextNode expand.
		treeNode := nextNode.
		nextNode := treeNode childrenNodes
			detect: [ :each |
				self gtIsPosition: position inComparison: each value last ]
			ifNone: [ nil ].
		nextNode notNil ] whileTrue.
	aTree selectOne: treeNode indexInTree.
	aTree children first scrollToPosition: treeNode indexInTree
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 20;
		title: 'Tree';
		items: [ { {'self'. #node. self} } ];
		children: [ :each | self gtChildrenOf: each ];
		column: 'Node' text: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ self stylesTextFor: each first for: each last ]
				ifFalse: [ (each value at: 2) = #token
					ifTrue: [ (each first)
						asRopedText foreground: BrGlamorousColors disabledButtonTextColor ]
					ifFalse: [each first ] ] ];
		column: 'Type'
			text: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ self nodeLabelFor: each last ]
				ifFalse: [ (each value at: 2) = #token
					ifTrue: [ ('token: "', each value last source asString, '"')
						asRopedText foreground: BrGlamorousColors disabledButtonTextColor ]
					ifFalse: [ '' ] ] ];
		column: 'Id'
			text: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ self idLabelFor: each last ]
				ifFalse: [ '' ] ];
		send: [ :each | each notNil ifTrue: [ each last ] ]
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> idLabelFor: aComparison [
	| text |
	text := (aComparison newAstNode id asString, (aComparison isReused ifTrue: [ ' (reused)' ] ifFalse: [ ' (new)' ])) asRopedText.
	^ self stylesTextFor: text for:aComparison
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> isReused [
	^ isReused = true
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> isReused: aBoolean [
	isReused := aBoolean
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> newAstNode [
	^ newAstNode
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> newAstNode: aNode [
	newAstNode := aNode
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> nodeLabelFor: aComparison [
	^ self stylesTextFor: aComparison newAstNode class name for: aComparison
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> oldAstNode [
	^ oldAstNode
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> oldAstNode: aNode [
	oldAstNode := aNode
]

{ #category : #printing }
GtIncrementalParserAstNodeComparison >> printOn: aStream [
	aStream
		print: newAstNode class name;
		nextPutAll: ' (';
		nextPutAll: (self isReused ifTrue: [ 'reused' ] ifFalse: [ 'new' ]);
		nextPut: $)
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> startPosition [
	^ newAstNode startPosition
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> stopPosition [
	^ newAstNode stopPosition
]

{ #category : #'gt views' }
GtIncrementalParserAstNodeComparison >> stylesTextFor: aString for: aComparison [
	| text |
	text := aString asRopedText.
	aComparison isReused ifTrue: [
		text foreground: BrGlamorousColors successBorderColor ].
	^ text
]

{ #category : #accessing }
GtIncrementalParserAstNodeComparison >> topParent [
	^ newAstNode topParent
]
