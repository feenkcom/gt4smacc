Class {
	#name : #GtSmaCCGrammarCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'grammarCoder'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'instance creation' }
GtSmaCCGrammarCoderElement class >> onCoder: aGrammarCoder [
	^ self new
		coder: aGrammarCoder;
		yourself
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> actionBar [
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
GtSmaCCGrammarCoderElement >> actions [
	^ {(GtCoderAction new
		title: 'Accept' translated;
		icon: BrGlamorousIcons accept;
		action: [ :button | self compileParser ];
		yourself)}
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> buildElement [
	self layout: BlLinearLayout vertical.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addChild:
			(GtSmaCCDefinitionListElement new
				group: grammarCoder group;
				yourself)
			as: #list;
		addChild: self actionBar
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoderElement >> coder: aGrammarCoder [
	grammarCoder := aGrammarCoder.
	self buildElement
]

{ #category : #actions }
GtSmaCCGrammarCoderElement >> compileParser [
	grammarCoder isValid
		ifFalse: [ ^ self showErrors ].
	grammarCoder compileParser
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> listElement [
	| list |
	list := BrSimpleList new.
	list vFitContent.
	list stencil: [ :each :index | each asElement ].
	list items: grammarCoder group coders.
	^ list asScrollableElement
]

{ #category : #private }
GtSmaCCGrammarCoderElement >> showErrors [
	| list |
	list := self childNamed: #list.
	list filterErrors
]
