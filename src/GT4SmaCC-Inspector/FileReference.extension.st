Extension { #name : #FileReference }

{ #category : #'*GT4SmaCC-Inspector' }
FileReference >> gtSmaCCRewritesFor: aView [
	<gtView>
	self extension = 'rw' ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Rewrites';
		priority: 1;
		object: [ SmaCCRewriteRuleFileParser parseFile: self ];
		view: #gtEditorFor:context:
]
