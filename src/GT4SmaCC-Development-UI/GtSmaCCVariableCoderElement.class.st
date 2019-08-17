Class {
	#name : #GtSmaCCVariableCoderElement,
	#superclass : #BrExpander,
	#instVars : [
		'coder'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCVariableCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #accessing }
GtSmaCCVariableCoderElement >> coder [
	^ coder
]

{ #category : #accessing }
GtSmaCCVariableCoderElement >> coder: aCoder [
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
GtSmaCCVariableCoderElement >> collapsedElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	element addChild: self labelElement.
	^ element
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> contentElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element margin: (BlInsets left: 5).
	element
		constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal matchParent ].
	element addChild: self labelElement.
	element addChildren: self referenceElements.
	^ element
]

{ #category : #'initialize-release' }
GtSmaCCVariableCoderElement >> initialize [
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
GtSmaCCVariableCoderElement >> isExpanded [
	^ expandableModel isExpanded
]

{ #category : #ui }
GtSmaCCVariableCoderElement >> labelElement [
	| label |
	label := BrLabel new.
	label padding: (BlInsets all: 2).
	label look: BrGlamorousLabelLook new glamorousCodeFontAndSize.
	label
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	label text: coder labelText.
	^ label
]

{ #category : #'as yet unclassified' }
GtSmaCCVariableCoderElement >> referenceElements [
	^ coder referencesText
		collect: [ :each | 
			| editorElement |
			editorElement := BrEditorElement new.
			editorElement
				margin:
					(BlInsets
						top: 2
						left: 15
						bottom: 0
						right: 15).
			editorElement padding: (BlInsets all: 2).
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ].
			editorElement
				editor:
					(BrTextEditor new
						text: each readonly;
						yourself).
			editorElement ]
]
