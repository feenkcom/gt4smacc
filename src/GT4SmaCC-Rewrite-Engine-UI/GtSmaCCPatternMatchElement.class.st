Class {
	#name : #GtSmaCCPatternMatchElement,
	#superclass : #GtSmaCCPatternElement,
	#category : #'GT4SmaCC-Rewrite-Engine-UI-UI'
}

{ #category : #'as yet unclassified' }
GtSmaCCPatternMatchElement >> connectToModel [
	super connectToModel.
	model ifNil: [ ^ self ].
	model announcer weak
		when: #startingState
		send: #updateStartingState
		to: self
]

{ #category : #initialization }
GtSmaCCPatternMatchElement >> initialize [
	| label stateList |
	super initialize.
	label := BrLabel new
			margin: (BlInsets top: 5 right: 5);
			fitContent;
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Starting state for parser:'.
	stateList := GtSmaCCDropDownList new
			margin: (BlInsets top: 3);
			items: #();
			when: BrSelectionChanged
				do: [ :event | model startingState: event target selectedItem ];
			yourself.
	self
		addChild: (BrHorizontalPane new
				margin: (BlInsets bottom: 5);
				vFitContent;
				hMatchParent;
				addChild: label;
				addChild: stateList as: #stateList)
		at: 1
]

{ #category : #private }
GtSmaCCPatternMatchElement >> patternStyler [
	^ (model
		ifNotNil: [ model rewrite parserClass ifNotNil: [ :pc | pc gtStyler ] ])
		ifNotNil: [ :styler | 
			styler startingState: model startingStateIndex.
			styler
				addStylerRule: (GtSmaCCNodeStylerRule new
						nodeClassName: #SmaCCPatternNode;
						styleBlock: [ :s | 
							s
								foreground: BrGlamorousColors linkColor;
								bold ]).
			styler ]
]

{ #category : #private }
GtSmaCCPatternMatchElement >> updateStartingState [
	model ifNil: [ ^ self ].
	self
		childNamed: #stateList
		ifFound: [ :dropdown | 
			dropdown
				items: ((model ifNotNil: [ model rewrite parserClass ])
						ifNil: [ #() ]
						ifNotNil: [ :cls | #(nil) , cls startingStateNames ]).
			dropdown selectedItem: model startingState ]
]

{ #category : #private }
GtSmaCCPatternMatchElement >> updateUI [
	super updateUI.
	self updateStartingState
]
