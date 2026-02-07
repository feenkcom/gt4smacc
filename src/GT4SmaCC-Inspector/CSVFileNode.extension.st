Extension { #name : #CSVFileNode }

{ #category : #'*GT4SmaCC-Inspector' }
CSVFileNode >> gtLinesFor: aView [
	<gtView>
	| list |
	list := aView columnedList
			title: 'Lines';
			priority: 1;
			items: [ self lines ].
	(1 to: self lines first values size)
		doWithIndex: [ :line :index | 
			list column: 'Column' text: [ :each | (each values at: index) value ] ].
	^ list
]
