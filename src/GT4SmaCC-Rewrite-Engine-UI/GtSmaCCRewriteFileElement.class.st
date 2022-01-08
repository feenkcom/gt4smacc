Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #GtSmaCCAbstractRewriteElement,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #building }
GtSmaCCRewriteFileElement >> build [
	self addChild: self parserElement.
	self updateParserClass
]

{ #category : #building }
GtSmaCCRewriteFileElement >> parserElement [
	| element |
	element := BrHorizontalPane new.
	element hMatchParent.
	element vFitContent.
	element
		addChild:
			((BrLabel new)
				margin: (BlInsets top: 5 right: 5);
				fitContent;
				aptitude: BrGlamorousLabelAptitude new;
				text: 'Parser:').
	element
		addChild:
			((GtSmaCCDropDownList new)
				margin: (BlInsets top: 5);
				items: (SmaCCParser allSubclasses asSortedCollection: [ :a :b | a name < b name ]);
				when: BrSelectionChanged do: [ :event | rewrite parserClass: event target selectedItem ])
		as: #parserClass.
	^ element
]

{ #category : #updating }
GtSmaCCRewriteFileElement >> update: aSymbol [
	aSymbol = #parserClass ifTrue: [ self updateParserClass ].
	^ super update: aSymbol
]

{ #category : #updating }
GtSmaCCRewriteFileElement >> updateParserClass [
	self childNamed: #parserClass ifFound: [ :list | list selectedItem: rewrite parserClass ]
]
