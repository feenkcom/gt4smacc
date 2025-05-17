Extension { #name : #CSVLineNode }

{ #category : #'*GT4SmaCC-Inspector' }
CSVLineNode >> gtValuesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Values';
		items: [ self values collect: [ :each | each value ] ];
		column: 'Value' text: [ :each | each gtDisplayString ]
]
