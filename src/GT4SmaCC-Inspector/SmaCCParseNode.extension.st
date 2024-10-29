Extension { #name : #SmaCCParseNode }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> asyncWithAllNodesStream [
	^ AsyncDepthFirstTraversalStream root: self children: [ :each | each children ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtAttributesFor: aView [
	<gtView>
	(attributes notNil and: [ attributes notEmpty ])
		ifFalse: [ ^ aView empty ].
	^ aView columnedList
		priority: 40;
		title: 'Attributes';
		items: [ attributes keys asSortedCollection ];
		column: 'Name' text: [ :each | each ];
		column: 'Value'
			text: [ :each | (self attributeNamed: each) printString ];
		send: [ :each | self attributeNamed: each ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtExploreFor: aView [
	<gtView>
	| topParent |
	topParent := self topParent.
	topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 5;
		title: 'Explore';
		stencil: [ | element editor tree |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			editor := self
				gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor.
			editor
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				beReadOnlyWithSelection;
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: editor.
			(topParent gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: tree.
			topParent gtHookEditor: editor toTree: tree children last.
			element ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtHookEditor: anEditor toTree: aTree [
	| highlightAttribute |
	highlightAttribute := (BlTextDecorationAttribute new underline)
		beNotOverwritableByStyler;
		color: BrGlamorousColors textHighlightColor;
		thickness: 3.
	aTree
		when: BrSelectionChanged
		do:
			[ :anEvent | 
			aTree
				selectedNodeDo:
					[ :aNode | 
					| item |
					item := aNode value last.
					((item isKindOf: SmaCCParseNode) or: [ item isKindOf: SmaCCToken ])
						ifTrue:
							[ anEditor editor text clearAttributes: [ :attr | attr == highlightAttribute ].
							anEditor editor text
								attributes: {highlightAttribute}
								from: item startPosition
								to: item stopPosition.
							self gtScrollToPosition: item startPosition inEditor: anEditor ] ] ].
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do:
			[ :event | 
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ self gtSelectItemIn: aTree at: position ] ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtIsPosition: anInteger inNode: aNode [
	(aNode startPosition isNil or: [ aNode stopPosition isNil ])
		ifTrue: [ ^ false ].
	^ anInteger between: aNode startPosition and: aNode stopPosition
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtParentsFor: aView [
	<gtView>
	^ aView tree
		priority: 30;
		title: 'Parents';
		items: [ {self} ];
		children: [ :each | 
			each parent isNil
				ifTrue: [ #() ]
				ifFalse: [ {each parent} ] ];
		expandAll;
		itemText: [ :each | each class name asRopedText glamorousRegularFontAndSize ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode class >> gtScroll: aString toPosition: anIndex inEditor: anEditor [
	anIndex isNil
		ifTrue: [ ^ self ].
	anEditor
		scrollToPosition:
			(aString asString
				lineNumberCorrespondingToIndex: anIndex)
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtScrollToPosition: index inEditor: editor [
	self class
		gtScroll: self topParent completeSource asString
		toPosition: index
		inEditor: editor
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSelectItemIn: aTree at: position [
	| treeNode nextNode |
	aTree collapseAll.
	nextNode := aTree viewModel itemAt: 1.
	[ nextNode expand.
	treeNode := nextNode.
	nextNode := treeNode childrenNodes
		detect: [ :each | 
			(#(#nodes #tokens) includes: each value second)
				ifTrue: [ each value last
						anySatisfy: [ :item | self gtIsPosition: position inNode: item ] ]
				ifFalse: [ (#(node token) includes: each value second)
						and: [ self gtIsPosition: position inNode: each value last ] ] ]
		ifNone: [ nil ].
	nextNode notNil ] whileTrue.
	aTree selectOne: treeNode indexInTree.
	aTree children first scrollToPosition: treeNode indexInTree
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode class >> gtSourceEditor: aTopNode withNode: aNodeOrToken highlight: aColor styler: aStyler [
	| anEditor aText aSource |
	aSource := aTopNode completeSource asString.
	aText := aSource asRopedText.
	aStyler ifNotNil: [ aStyler style: aText ast: aTopNode ].
	aNodeOrToken stopPosition isZero
		ifFalse: [ (aText from: aNodeOrToken startPosition to: aNodeOrToken stopPosition)
				attributes: {BlTextHighlightAttribute new
							beNotOverwritableByStyler;
							paint: aColor} ].
	anEditor := BrEditor new
			text: aText;
			aptitude: BrGlamorousCodeEditorAptitude new.
	self
		gtScroll: aSource
		toPosition: aNodeOrToken startPosition
		inEditor: anEditor.
	^ anEditor
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceEditorWithHighlight: aColor [
	^ self
		gtSourceEditorWithHighlight: aColor
		styler: (self parserClass ifNotNil: [ :class | class gtStyler ])
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceEditorWithHighlight: aColor styler: styler [
	^ self class
		gtSourceEditor: self topParent
		withNode: self
		highlight: aColor
		styler: styler
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceFor: aView [
	<gtView>
	self topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Source';
		stencil: [ 
			self gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSpotterNodeFor: aSearch [
	<gtSearch>
	| source |
	source := self topParent completeSource.
	^ aSearch list
		priority: 10;
		title: 'Nodes';
		items: [ self asyncWithAllNodesStream ];
		itemName: [ :node | 
			[ | start stop |
			start := node startPosition.
			stop := node stopPosition.
			(source copyFrom: start to: (stop min: start + 100)) asString ]
				on: Error
				do: [ :ex | ex return: node class name ] ];
		filter: GtSmaCCASTFilter new
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 20;
		title: 'Tree';
		items: [ {{'self'.
			#node.
			self}} ];
		children: [ :each | self gtChildrenOf: each ];
		column: 'Node' text: [ :each | each value first ];
		column: 'Type'
			text: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ each value last class name ]
				ifFalse: [ (each value at: 2) = #token
					ifTrue: [ ('token: "', each value last source asString, '"')
						asRopedText foreground: BrGlamorousColors disabledButtonTextColor ]
					ifFalse: [ '' ] ] ];
		send: [ :each | 
			each notNil
				ifTrue: [ each last ] ]
]
