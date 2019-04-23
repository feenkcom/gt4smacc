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
		addChild: self compilationBar
]

{ #category : #'initialize-release' }
GtSmaCCGrammarCoderElement >> coder: aGrammarCoder [
	grammarCoder := aGrammarCoder.
	self buildElement
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> compilationBar [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element addChild: self actionBar.
	element addChild: self flagsElement.
	^ element
]

{ #category : #actions }
GtSmaCCGrammarCoderElement >> compileParser [
	grammarCoder isValid
		ifFalse: [ ^ self showErrors ].
	grammarCoder compileParser
]

{ #category : #ui }
GtSmaCCGrammarCoderElement >> flagsElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout horizontal.
	element margin: (BlInsets top: 3).
	element
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	element
		addChild: (self toggleButton: 'GLR' activated: #isGLR)
		as: #glr.
	element
		addChild:
			(self toggleButton: 'Case insentive' activated: #isCaseInsensitive)
		as: #caseInsensitive.
	element
		addChild: (self toggleButton: 'Unicode' activated: #isUnicode)
		as: #unicode.
	^ element
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

{ #category : #ui }
GtSmaCCGrammarCoderElement >> toggleButton: aString activated: aSymbol [
	| toggle |
	toggle := BrToggle new
		layout: BlLinearLayout horizontal alignCenter;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical exact: 20.
			c padding: (BlInsets all: 6) ];
		activated: (grammarCoder perform: aSymbol);
		margin:
			(BlInsets
				top: 0
				left: 2
				bottom: 0
				right: 2);
		constraintsDo: [ :c | 
			c frame horizontal alignRight.
			c frame vertical alignTop ];
		label:
			(aString asRopedText
				attributes:
					{(BlFontSizeAttribute size: 12).
					(BlFontFamilyAttribute named: 'Source Sans Pro')});
		look: GtCoderToggleLook;
		when: BrToggleActivatedEvent
			do:
				[ :anEvent | grammarCoder perform: (aSymbol , ':') asSymbol with: true ];
		when: BrToggleDeactivatedEvent
			do:
				[ :anEvent | grammarCoder perform: (aSymbol , ':') asSymbol with: false ].
	^ toggle
]
