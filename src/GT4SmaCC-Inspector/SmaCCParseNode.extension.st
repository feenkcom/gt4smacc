Extension { #name : #SmaCCParseNode }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtAttributesFor: aView [
	<gtView>
	(attributes notNil and: [ attributes notEmpty ])
		ifFalse: [ ^ aView empty ].
	^ aView columnedList
		priority: 40;
		title: 'Attributes';
		items: [ attributes keys asSortedCollection ];
		column: 'Name' format: [:each | each ];
		column: 'Value' format: [ :each | (self attributeNamed: each) printString ];
		send: [:each | self attributeNamed: each ]
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
			editor := self gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor.
			editor
				look: BrShadowLook;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: editor.
			(topParent gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				look: BrShadowLook;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: tree.
			topParent gtHookEditor: editor toTree: tree children last.
			element ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtHookEditor: anEditor toTree: aTree [
	| highlighter highlightAttribute |
	highlighter := GtTextNodeHighlighter
		on: anEditor
		source: self topParent completeSource asString.
	highlightAttribute := BlTextUnderlineAttribute new
		beNotOverwritableByStyler;
		paint: BrGlamorousColors textHighlightColor;
		width: 3.
	aTree
		when: BrSelectionChanged
		do: [ :anEvent | 
			aTree
				selectedNodeDo: [ :aNode | 
					| item |
					item := aNode value last.
					((item isKindOf: SmaCCParseNode)
						or: [ item isKindOf: SmaCCToken ])
						ifTrue: [ anEditor editor text
								clearAttributes: [ :attr | attr == highlightAttribute ].
							highlighter highlight: item with: highlightAttribute.
							self gtScrollToPosition: item startPosition inEditor: anEditor ] ] ].
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do: [ :event | 
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil
				ifTrue: [ self
						gtSelectItemIn: aTree
						at: (highlighter stringPositionFor: position) ] ]
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
		itemFormat: [ :each | each class name asRopedText glamorousRegularFontAndSize ];
		send: [ :each | each value ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtScrollToPosition: index inEditor: editor [
	editor
		scrollToPosition:
			(self topParent completeSource asString
				lineNumberCorrespondingToIndex: index)
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
	aTree selectOne: treeNode globalIndexInTree.
	aTree children first scrollToPosition: treeNode globalIndexInTree
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceEditorWithHighlight: aColor [
	| source editor |
	source := BlRopedRawText
		string: self topParent completeSource asString.
	self parserClass
		ifNotNil: [ :class | 
			class gtStyler
				ifNotNil: [ :styler | styler style: source using: self topParent ] ].
	(source from: self startPosition to: self stopPosition)
		attributes:
			{(BlTextHighlightAttribute new
				beNotOverwritableByStyler;
				paint: aColor)}.
	editor := BrEditor new
		text: source;
		look: BrGlamorousCodeEditorLook new.
	self gtScrollToPosition: self startPosition inEditor: editor.
	^ editor
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
SmaCCParseNode >> gtSpotterNodeFor: aStep [
	<gtSearch>
	| source |
	source := self topParent completeSource.
	aStep listProcessor
		priority: 10;
		title: 'Nodes';
		allCandidates: [ | nodes |
			nodes := OrderedCollection with: self.
			self allNodesDo: [ :each | nodes add: each ].
			nodes ];
		itemName: [ :node | 
			[ | start stop |
			start := node startPosition.
			stop := node stopPosition.
			(source copyFrom: start to: (stop min: start + 100)) asString ]
				on: Error
				do: [ :ex | ex return: node class name ] ];
		filter: GtSmaCCASTFilter
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
		column: 'Node' format: [ :each | each value first ];
		column: 'Type'
			format: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ each value last class name ]
				ifFalse: [ '' ] ];
		send: [ :each | 
			each notNil
				ifTrue: [ each last ] ]
]
