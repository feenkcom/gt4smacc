Extension { #name : #SmaCCString }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCString >> gtSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'String';
		stencil: [ | editor source |
			source := BlRopedRawText string: self asString.
			editor := BrEditor new
				text: source;
				look: BrGlamorousCodeEditorLook new.
			editor ]
]
