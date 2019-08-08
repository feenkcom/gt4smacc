Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> buildSmaCCGrammarTabIn: tabGroup for: classCoder [
	<gtClassView: 5>
	self definitionString isEmpty
		ifTrue: [ ^ self ].
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Grammar';
				stencil: [ (GtSmaCCGrammarCoder onParser: self) asElement ])
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParser class >> gtCoderFor: aView [
	<gtView>
	self definitionString isEmpty
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		title: 'Grammar';
		priority: 1;
		stencil: [ (GtSmaCCGrammarCoder onParser: self) asElement ]
]
