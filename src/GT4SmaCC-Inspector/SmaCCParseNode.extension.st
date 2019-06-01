Extension { #name : #SmaCCParseNode }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtAttributesFor: aView [
	<gtView>
	(attributes notNil and: [ attributes notEmpty ])
		ifFalse: [ ^ aView empty ].
	^ aView explicit
		priority: 40;
		title: 'Attributes';
		stencil: [ | list |
			list := BrColumnedList new.
			list items: attributes keys asSortedCollection.
			list
				when: BrSelectionChanged
				do: [ :event | 
					event selection
						do: [ :each | 
							list phlow
								selectObject: (self attributeNamed: (list items at: each from)) ] ].
			list column
				title: 'Name';
				stencil: [ :each | BrColumnCellLabelStencil new text: each ].
			list column
				title: 'Value';
				stencil: [ :each | 
					BrColumnCellLabelStencil new
						text: (self attributeNamed: each) printString ].
			list ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtParentsFor: aView [
	<gtView>
	^ aView explicit
		priority: 30;
		title: 'Parents';
		stencil: [ | tree index |
			tree := BrSimpleTree new.
			tree
				items: {self}
				children: [ :each | 
					each parent isNil
						ifTrue: [ #() ]
						ifFalse: [ {each parent} ] ].
			index := 1.
			[ index <= tree viewModel itemCount ]
				whileTrue: [ (tree viewModel itemAt: index) expand.
					index := index + 1 ].
			tree
				stencil:
					(BrSimpleTreeRowStencilBuilder new
						text: [ :each | each class name asRopedText glamorousRegularFontAndSize ]).
			tree
				when: BrSelectionChanged
				do:
					[ :anEvent | tree selectedNodeDo: [ :aNode | tree phlow selectObject: aNode value ] ].
			tree ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'Source';
		stencil: [ | source editor |
			source := self topParent completeSource asString asRopedText.
			self parserClass
				ifNotNil: [ :class | 
					class gtStyler
						ifNotNil: [ :styler | styler style: source using: self topParent ] ].
			(source from: self startPosition to: self stopPosition)
				attributes:
					{(BlTextUnderlineAttribute new
						beNotOverwritableByStyler;
						paint: BrGlamorousColors primaryBorderColor)}.
			editor := BrEditor new
				text: source;
				look: BrGlamorousCodeEditorLook new.
			editor
				scrollToPosition: (source asString lineNumberCorrespondingToIndex: self startPosition).
			editor ]
]

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCParseNode >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 20;
		title: 'Tree';
		items: [
			{{'self'.
			#node.
			self}} ];
		children: [ :each | self gtChildrenOf: each ];
		column: 'Variable' format: [:each | each value first ];
		column: 'Type' format: [:each |
			((each value at: 2) = #node
					ifTrue: [ each value last class name ]
					ifFalse: [ '' ]) ]
]
