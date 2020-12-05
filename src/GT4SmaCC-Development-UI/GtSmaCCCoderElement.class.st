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
		look: BrGlamorousToolbarLook new;
		addItems:
			(coder actions
				collect: [ :each | 
					BrButton new
						beSmall;
						look: BrGlamorousButtonWithIconLook;
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
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	label := BrEditorElement new.
	label padding: (BlInsets all: 2).
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	label editor: coder collapsedEditor.
	element addChild: label.
	^ element
]

{ #category : #ui }
GtSmaCCCoderElement >> contentElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	element addChild: self sourceEditor.
	element addChild: self actionBar.
	^ element
]

{ #category : #ui }
GtSmaCCCoderElement >> deleteElement [
	^ GtInspectorRoundButtonStencil new asElement
		icon: GtInspectorPlusIconStencil close asElement;
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
	| resizer |
	super initialize.
	self
		vFitContent;
		hMatchParent;
		clipChildren: false.
	self addChild: self deleteElement as: #deleteButton.
	resizer := BrResizer new
		beBottom;
		look: BrGlamorousResizerLook new;
		constraintsDo: [ :c | c ignoreByLayout ];
		when: BlDoubleClickEvent
			do: [ self
				childNamed: #bodyEditor
				ifFound: [ :anEditor | anEditor constraintsDo: [ :c | c vertical fitContent ] ]
				ifNone: [  ] ];
		yourself.
	self
		look:
			(GtCoderExpanderLook new
				borderWidth: 0;
				padding:
					(BlInsets
						top: 1
						left: 10
						bottom: 1
						right: 10))
				+
					(BrInteractiveLook new
						style: [ :aStyler | 
							aStyler
								default: [ resizer removeFromParent.
									self background: Color transparent ].
							aStyler
								expanded: [ self addChild: resizer.
									self
										enqueueTask:
											(BlTaskAction new
												action: [ self
														childNamed: #bodyEditor
														ifFound: [ :anEditor | resizer target: anEditor ]
														ifNone: [ resizer target: nil ] ]).
									self background: Color white ] ]).
	self
		addShortcut:
			(BlShortcutWithAction new
				combination:
					(BlKeyCombination builder
						primary;
						return;
						build);
				action: [ self toggle ])
]

{ #category : #ui }
GtSmaCCCoderElement >> sourceEditor [
	| element |
	element := BrEditor new.
	element padding: (BlInsets all: 2).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
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
