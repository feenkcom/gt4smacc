Extension { #name : #SmaCCParseNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCParseNode >> gtCommentsFor: aView [
	<gtView>
	self comments ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Comments';
		items: [ self comments ];
		column: 'Comment' text: [ :each | self completeSource asString copyFrom: each first to: each second ]; 
		column: 'From' text: [ :each | each first ] width: 80;
		column: 'To' text: [ :each | each second ] width: 80
]
