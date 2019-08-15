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
SmaCCParseNode >> gtSourceFor: aView [
	<gtView>
	self topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
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
