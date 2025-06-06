Extension { #name : #SmaCCToken }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCToken >> gtSourceFor: aView context: aGtPhlowContext [
	<gtView>
	| aNode aSource |
	aGtPhlowContext navigation
		previousObjectSuchThat: [ :anObject |
			anObject isKindOf: SmaCCParseNode ]
		do: [ :anObject | 
			aNode := anObject.
			aSource := anObject topParent completeSource ]
		ifAbsent: [ ^ aView empty ].
	aSource ifNil: [ ^ aView empty ].
		
	^ aView explicit
		priority: 10;
		title: 'Source';
		stencil: [ SmaCCParseNode 
			gtSourceEditor: aNode topParent 
			withNode: self 
			highlight: BrGlamorousColors neutralBackgroundColor 
			styler: (aNode parserClass ifNotNil: [ :class | class gtStyler ]) ]
]
