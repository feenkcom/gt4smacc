Extension { #name : #SmaCCParser }

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
