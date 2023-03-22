Extension { #name : #SmaCCAnnotatedStringInterval }

{ #category : #'*GT4SmaCC-Inspector' }
SmaCCAnnotatedStringInterval >> gtStringFor: aView [
	<gtView>
	| text |
	^ aView textEditor 
		title: 'String';
		text: [ text := string asRopedText.
(text from: start to: stop) highlight: BrGlamorousColors neutralBackgroundColor.
text ]
]
