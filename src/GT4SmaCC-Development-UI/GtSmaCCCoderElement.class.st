Class {
	#name : #GtSmaCCCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'coder'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #ui }
GtSmaCCCoderElement >> actionBar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		addItems:
			(coder actions
				collect: [ :each | 
					BrButton new
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: each title;
						icon: each icon asElement;
						action: each ])
]

{ #category : #accessing }
GtSmaCCCoderElement >> coder [
	^ coder
]

{ #category : #'initialize-release' }
GtSmaCCCoderElement >> coder: aCoder [
	coder := aCoder.
	coder owner weak
		when: GtSmaCCCoderAnnouncement
		send: #updateDeleteButton
		to: self.
	self header: [ self collapsedElement ].
	self content: [ self contentElement ].
	self margin: (BlInsets all: 4).

	self
		when: BrExpandedEvent
		do: [ :event | coder expanded: true ].	
	self
		when: BrCollapsedEvent
		do: [ :event | coder expanded: false ].	
	
	coder expanded
		ifTrue: [ self expand ].
	self updateDeleteButton
]

{ #category : #ui }
GtSmaCCCoderElement >> collapsedElement [
	| element label |
	element := BrVerticalPane new.
	element margin: (BlInsets left: 5).
	element vFitContent.
	element hMatchParent.
	label := BrEditor new.
	label beReadOnlyWithoutSelection.
	label padding: (BlInsets all: 2).
	label hMatchParent.
	label vFitContent.
	label editor: coder collapsedEditor.
	element addChild: label.
	^ element
]

{ #category : #ui }
GtSmaCCCoderElement >> contentElement [
	| element |
	element := BrVerticalPane new.
	element margin: (BlInsets left: 5).
	element vFitContent.
	element hMatchParent.
	element addChild: self sourceEditor as: #editor.
	element addChild: self actionBar as: #actionBar.
	^ element
]

{ #category : #ui }
GtSmaCCCoderElement >> deleteElement [
	^ GtInspectorRoundButtonStencil new asElement
		icon: BrPlusIconStencil close asElement;
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c
				margin:
					(BlInsets
						top: -10
						left: 0
						bottom: 0
						right: -10).
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		action: [ :e | coder deleteRule ]
]

{ #category : #'initialize-release' }
GtSmaCCCoderElement >> initialize [
	super initialize.
	self
		vFitContent;
		hMatchParent;
		clipChildren: false.
	self addChild: self deleteElement as: #deleteButton.
	self
		background: Color white;
		aptitude:
				((GtCoderExpanderAptitude new)
						borderWidth: 0;
						padding:
								(BlInsets
										top: 1
										left: 10
										bottom: 1
										right: 10)).
	self
		addShortcut:
			((BlShortcutWithAction new)
				combination:
						((BlKeyCombination builder)
								primary;
								enter;
								build);
				action: [ self toggleExpanded ])
]

{ #category : #ui }
GtSmaCCCoderElement >> sourceEditor [
	| element |
	element := BrEditor new.
	element padding: (BlInsets all: 2).
	element hMatchParent.
	element vFitContent.
	element editor: coder sourceEditor.
	element styler: element editor styler.
	element editor styleText.
	coder addShortcutsTo: element.
	coder completionStrategy
		ifNotNil: [ :strategy | 
			| completionController |
			completionController := GtCompletionController
				on: element
				strategy: strategy.
			completionController closeOnEmptyCompletion: false.
			completionController install ].
	^ element
]

{ #category : #private }
GtSmaCCCoderElement >> updateDeleteButton [
	self
		childNamed: #deleteButton
		ifFound: [ :button | 
			button
				visibility:
					(coder isReferenced
						ifTrue: [ BlVisibility hidden ]
						ifFalse: [ BlVisibility visible ]) ]
		ifNone: [  ]
]
