Extension { #name : #GtClassCoderElement }

{ #category : #'*GT4SmaCC-Development-UI' }
GtClassCoderElement >> buildSmaCCGrammarTabIn: tabGroup [
	<gtClassCoderTab: 5>
	(classCoder theClass includesBehavior: SmaCCParser)
		ifFalse: [ ^ self ].
	classCoder theClass definitionString isEmpty
		ifTrue: [ ^ self ].
	tabGroup
		addTab:
			(BrTab new
				look: BrGlamorousTabLook new;
				label: 'Grammar';
				stencil: [ (GtSmaCCGrammarCoder onParser: classCoder theClass) asElement ])
]
