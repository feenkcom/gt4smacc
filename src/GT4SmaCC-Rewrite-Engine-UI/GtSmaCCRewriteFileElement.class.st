Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'initialize-release' }
GtSmaCCRewriteFileElement >> contentElement [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: self rewritesElement;
		yourself
]

{ #category : #ui }
GtSmaCCRewriteFileElement >> headerElement [
	| header |
	header := super headerElement.
	header layout: BlFrameLayout new.
	header addChild: self parserElement.
	(header childNamed: #label)
		constraintsDo: [ :c | c frame vertical alignCenter ].
	^ header
]

{ #category : #'initialize-release' }
GtSmaCCRewriteFileElement >> parserDropDown [
	^ GtSmaCCDropDownList new
		selectedItem: rewrite parserClass;
		items:
			(SmaCCParser allSubclasses
				asSortedCollection: [ :a :b | a name < b name ]);
		when: BrSelectionChanged
			do: [ :event | rewrite parserClass: event target selectedItem ]
]

{ #category : #'initialize-release' }
GtSmaCCRewriteFileElement >> parserElement [
	| label |
	label := BrLabel new
		text: 'Parser:';
		aptitude: BrGlamorousLabelAptitude new;
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

{ #category : #'initialize-release' }
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
