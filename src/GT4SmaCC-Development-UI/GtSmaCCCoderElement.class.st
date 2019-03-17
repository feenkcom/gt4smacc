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
		look: BrToolbarLook new;
		layout:
			(BlGridLayout horizontal
				rowCount: 1;
				cellSpacing: 3);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
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

{ #category : #'initialize-release' }
GtSmaCCCoderElement >> coder: aCoder [
	coder := aCoder.
	self header: [ self collapsedElement ].
	self content: [ self contentElement ].
	self margin: (BlInsets all: 4).
	expandableModel
		when: BrExpansionChanged
		do: [ :event | coder expanded: self isExpanded ].
	coder expanded
		ifTrue: [ self expand ]
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

{ #category : #'initialize-release' }
GtSmaCCCoderElement >> initialize [
	| resizer |
	super initialize.
	self
		vFitContent;
		hMatchParent.
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
			(BlShortcut new
				combination:
					(BlKeyCombination builder
						primary;
						return;
						build);
				action: [ self toggle ])
]

{ #category : #testing }
GtSmaCCCoderElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #ui }
GtSmaCCCoderElement >> sourceEditor [
	| editor |
	editor := BrEditorElement new.
	editor
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	editor editor: coder sourceEditor.
	^ editor
]
