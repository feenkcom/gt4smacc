Class {
	#name : #GtSmaCCListCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCListCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #ui }
GtSmaCCListCoderElement >> actionBar [
	^ BrToolbar new
		look: BrToolbarLook new;
		padding:
			(BlInsets
				top: 0
				left: 10
				bottom: 5
				right: 10);
		layout:
			(BlGridLayout horizontal
				rowCount: 1;
				cellSpacing: 3);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addItems:
			(self actions
				collect: [ :each | 
					BrButton new
						beSmall;
						look: BrGlamorousButtonWithIconLook;
						label: each title;
						icon: each icon asElement;
						action: each ])
]

{ #category : #ui }
GtSmaCCListCoderElement >> actions [
	^ {(GtCoderAction new
		title: 'Accept' translated;
		icon: BrGlamorousIcons accept;
		action: [ :button | self compileParser ];
		yourself)}
]

{ #category : #ui }
GtSmaCCListCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addChild:
			(self coderListElementClass new
				group: self group;
				yourself)
			as: #list;
		addChild: self compilationBar
]

{ #category : #'initialize-release' }
GtSmaCCListCoderElement >> coder: aGrammarCoder [
	grammarCoder := aGrammarCoder.
	grammarCoder weak
		when: GtSmaCCCoderRulesChangedAnnouncement
		send: #updateList
		to: self.
	self buildElement
]

{ #category : #ui }
GtSmaCCListCoderElement >> coderListElementClass [
	^ self subclassResponsibility
]

{ #category : #ui }
GtSmaCCListCoderElement >> compilationBar [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: self actionBar.
	^ element
]

{ #category : #actions }
GtSmaCCListCoderElement >> compileParser [
	grammarCoder isValid
		ifFalse: [ ^ self showErrors ].
	grammarCoder compileParser
]

{ #category : #accessing }
GtSmaCCListCoderElement >> group [
	^ self subclassResponsibility
]

{ #category : #ui }
GtSmaCCListCoderElement >> listElement [
	| list |
	list := BrSimpleList new.
	list vFitContent.
	list stencil: [ :each :index | each asElement ].
	list items: self group coders.
	^ list asScrollableElement
]

{ #category : #private }
GtSmaCCListCoderElement >> showErrors [
]

{ #category : #ui }
GtSmaCCListCoderElement >> updateList [
	self
		childNamed: #list
		ifFound: [ :element | element updateFilters ]
		ifNone: [  ]
]
