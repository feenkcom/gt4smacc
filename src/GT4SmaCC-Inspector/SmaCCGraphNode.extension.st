Extension { #name : #SmaCCGraphNode }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCGraphNode >> gtGraphViewIn: aView [
	<gtView>
	^ aView mondrian
		title: 'Graph';
		painting: [ :mondrian | parser buildMondrian: mondrian forStack: self stack ]
]
