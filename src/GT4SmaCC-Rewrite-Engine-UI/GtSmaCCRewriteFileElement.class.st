Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #initialization }
GtSmaCCRewriteFileElement >> contentElement [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		"addChild: self parserElement;"
		addChild: self rewritesElement;
		yourself
]

{ #category : #updating }
GtSmaCCRewriteFileElement >> headerElement [
	| header |
	header := super headerElement.
	header layout: BlFrameLayout new.
	header addChild: self parserElement.
	(header childNamed: #label)
		ifNotNil:
			[ :label | label constraintsDo: [ :c | c frame vertical alignCenter ] ].
	^ header
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> parserDropDown [
	| dropdown |
	dropdown := BrDropdown new.
	dropdown layout: BlLinearLayout horizontal.
	dropdown
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	dropdown
		toggle: [ self parserDropDownButton action: [ dropdown toggle ] ].
	dropdown popup: [ self popupParserClassListFor: dropdown ].
	dropdown
		look:
			(BrDropdownLook new
				outskirtsEmbellisher: [ :e | e look: BrDropdownOutskirtsLook new ]).
	^ dropdown
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> parserDropDownButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		padding:
			(BlInsets
				top: 3
				left: 5
				bottom: 3
				right: 5);
		constraintsDo: [ :c | c minWidth: 150 ];
		label: (rewrite parserClass ifNil: [ '' ] ifNotNil: [ :cls | cls name ]);
		yourself
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> parserElement [
	| label |
	label := BrLabel new
		text: 'Parser:';
		look: BrGlamorousLabelLook new;
		padding: (BlInsets all: 5);
		hFitContent;
		yourself.
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c frame horizontal alignRight.
			c horizontal fitContent.
			c vertical fitContent ];
		addChild: label;
		addChild: self parserDropDown;
		yourself
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> popupParserClassListFor: aDropDown [
	| list |
	list := BrSimpleList new.
	list vExact: 200.
	list hFitContent.
	list
		stencil: [ :each :index | 
			BrLabel new
				look: BrGlamorousLabelLook new;
				padding: (BlInsets all: 5);
				text: each name;
				hFitContent;
				when: BlClickEvent
					do: [ :anEvent | 
					anEvent consumed: true.
					list selectOne: index.
					aDropDown collapse ];
				yourself ].
	list
		items:
			(SmaCCParser allSubclasses
				asSortedCollection: [ :a :b | a name < b name ]).
	^ list
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> rewritesElement [
	| list |
	list := BrSimpleList new.
	list vFitContent.
	list
		stencil: [ :each :index | 
			each element
				margin:
					(BlInsets
						top: 2
						left: 5
						bottom: 5
						right: 5);
				yourself ].
	list items: rewrite rewrites.
	^ list
]

{ #category : #updating }
GtSmaCCRewriteFileElement >> updateContent [
	rewrite isRoot
		ifTrue: [ self expand ].
	super updateContent
]
