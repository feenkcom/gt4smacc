Class {
	#name : #GtSmaCCListCoderElement,
	#superclass : #BrVerticalPane,
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
		aptitude: BrGlamorousToolbarAptitude new;
		padding:
			(BlInsets
				top: 0
				left: 10
				bottom: 5
				right: 10);
		addItems:
			(self actions
				collect: [ :each | 
					BrButton new
						beSmallSize;
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: each title;
						icon: each icon asElement;
						action: each ])
]

{ #category : #ui }
GtSmaCCListCoderElement >> actions [
	^ {(GtCoderAction new
		title: 'Accept' translated;
		icon: BrGlamorousVectorIcons accept;
		action: [ :button | self compileParser ];
		yourself)}
]

{ #category : #ui }
GtSmaCCListCoderElement >> buildElement [
	self matchParent.
	self
		addChild:
				((self coderListElementClass new)
						group: self group;
						yourself)
			as: #list;
		addChild: self compilationBar
]

{ #category : #accessing }
GtSmaCCListCoderElement >> coder [
	^ grammarCoder
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
		constraintsDo:
			[ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: self actionBar as: #actionBar.
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
	list clipChildren: false.
	^ list asScrollableElement
]

{ #category : #ui }
GtSmaCCListCoderElement >> showDefinition: aString [
	grammarCoder grammar: (GtSmaCCGrammar forDefinition: aString).
	self updateList
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
