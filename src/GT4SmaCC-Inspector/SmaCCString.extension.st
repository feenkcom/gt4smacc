Extension { #name : #SmaCCString }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCString >> gtSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'String';
		stencil: [ | editor source |
			source := self asString asRopedText.
			editor := BrEditor new
				text: source;
				aptitude: BrGlamorousCodeEditorAptitude new.
			editor ]
]
