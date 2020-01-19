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
	parent notNil
		ifTrue: [ ^ self topParent gtExploreFor: aView ].
	self completeSource isNil
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
			editor := self gtSourceEditor look: BrShadowLook; background: Color white; margin: (BlInsets all: 10).
			element addChild: editor.
			(self gtTreeFor: GtPhlowView empty) asElementDo: [ :e | 
				tree := e look: BrShadowLook; background: Color white; margin: (BlInsets all: 10).].
			element addChild: tree.
			self gtHookEditor: editor toTree: tree children last.
			element ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtHighlightFrom: start to: stop in: anEditor [
	| text |
	(start isNil or: [ stop isNil or: [ start = 0 or: [ stop = 0 ] ] ])
		ifTrue: [ ^ self ].
	text := anEditor text.
	text
		clearAttributes: [ :attr | attr isKindOf: BlTextUnderlineAttribute ].
	(text from: start to: stop)
		attributes:
			{(BlTextUnderlineAttribute new
				beNotOverwritableByStyler;
				paint: BrGlamorousColors primaryBorderColor)}.
	anEditor text: text.
	self gtScrollToPosition: start inEditor: anEditor
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtHookEditor: anEditor toTree: aTree [
	| updating |
	updating := false.
	aTree
		when: BrSelectionChanged
		do: [ :anEvent | 
			updating
				ifFalse: [ updating := true.
					[ aTree
						selectedNodeDo: [ :aNode | 
							| item |
							item := aNode value last.
							((item isKindOf: SmaCCParseNode)
								or: [ item isKindOf: SmaCCToken ])
								ifTrue: [ self
										gtHighlightFrom: item startPosition
										to: item stopPosition
										in: anEditor ] ] ]
						ensure: [ updating := false ] ] ].
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do: [ :event | 
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil
				ifTrue: [ self gtSelectItemIn: aTree at: position ] ]
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
"			index := 1.
			[ index <= tree viewModel itemCount ]
				whileTrue: [ (tree viewModel itemAt: index) expand.
					index := index + 1 ]."
		itemFormat: [ :each | each class name asRopedText glamorousRegularFontAndSize ];
		send: [:each | each value ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtScrollToPosition: index inEditor: editor [
	editor
		scrollToPosition: (editor text asString lineNumberCorrespondingToIndex: index)
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
						anySatisfy:
							[ :item | position between: item startPosition and: item stopPosition ] ]
				ifFalse: [ (#(node token) includes: each value second)
						and: [ position
								between: each value last startPosition
								and: each value last stopPosition ] ] ]
		ifNone: [ nil ].
	nextNode notNil ] whileTrue.
	aTree selectOne: treeNode globalIndexInTree
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceEditor [
	| source |
	source := BlRopedRawText
		string: self topParent completeSource asString.
	self parserClass
		ifNotNil: [ :class | 
			class gtStyler
				ifNotNil: [ :styler | styler style: source using: self topParent ] ].
	(source from: self startPosition to: self stopPosition)
		attributes:
			{(BlTextUnderlineAttribute new
				beNotOverwritableByStyler;
				paint: BrGlamorousColors primaryBorderColor)}.
	^ BrEditor new
		text: source;
		look: BrGlamorousCodeEditorLook new
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceFor: aView [
	<gtView>
	self topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'Source';
		stencil: [ | editor |
			editor := self gtSourceEditor.
			self gtScrollToPosition: self startPosition inEditor: editor.
			editor ]
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
		column: 'Variable' format: [ :each | each value first ];
		column: 'Type'
			format: [ :each | 
			(each value at: 2) = #node
				ifTrue: [ each value last class name ]
				ifFalse: [ '' ] ];
		send: [ :each | 
			each notNil
				ifTrue: [ each last ] ]
]
