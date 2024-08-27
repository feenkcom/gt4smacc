Class {
	#name : #GtSmaCCMatchCodeElement,
	#superclass : #GtSmaCCCodeElement,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'as yet unclassified' }
GtSmaCCMatchCodeElement >> connectToModel [
	super connectToModel.
	model ifNil: [ ^ self ].
	model announcer weak
		when: #nodeClass
		send: #updateNodeClass
		to: self
]

{ #category : #initialization }
GtSmaCCMatchCodeElement >> initialize [
	| label nodeList |
	super initialize.

	label := BrLabel new
			margin: (BlInsets top: 5 right: 5);
			fitContent;
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Match nodes of type:'.
	nodeList := GtSmaCCDropDownList new
			margin: (BlInsets top: 3);
			items: self nodeClasses;
			when: BrSelectionChanged
				do: [ :event | model nodeClass: event target selectedItem ];
			yourself.
	self
		addChild: (BrHorizontalPane new
				margin: (BlInsets bottom: 5);
				vFitContent;
				hMatchParent;
				addChild: label;
				addChild: nodeList as: #nodeList)
		at: 1
]

{ #category : #private }
GtSmaCCMatchCodeElement >> nodeClasses [
	| classes parserNodeClasses |
	classes := SmaCCParseNode allSubclasses.
	parserNodeClasses := self parserNodeClasses.
	^ classes
		asSortedCollection:
			[ :a :b | 
			| aSortAtTop |
			(aSortAtTop := parserNodeClasses includes: a) = (parserNodeClasses includes: b)
				ifTrue: [ a name < b name ]
				ifFalse: [ aSortAtTop ] ]
]

{ #category : #private }
GtSmaCCMatchCodeElement >> parserNodeClasses [
	(model ifNotNil: [ model rewrite parserClass ])
		ifNotNil: [ :pc | 
			pc symbolTypes
				do: [ :each | 
					| cls supers |
					(each ~= #SmaCCParseNode
						and: [ (cls := Smalltalk at: each) includesBehavior: SmaCCParseNode ])
						ifTrue: [ supers := cls withAllSuperclasses.
							^ (supers at: supers size - SmaCCParseNode withAllSuperclasses size)
								withAllSubclasses asSet ] ] ].
	^ #()
]

{ #category : #private }
GtSmaCCMatchCodeElement >> updateNodeClass [
	self
		childNamed: #nodeList
		ifFound: [ :dropdown | dropdown selectedItem: model nodeClass ]
]

{ #category : #private }
GtSmaCCMatchCodeElement >> updateUI [
	super updateUI.
	self updateNodeClass
]