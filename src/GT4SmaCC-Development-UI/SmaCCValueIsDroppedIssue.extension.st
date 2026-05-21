Extension { #name : #SmaCCValueIsDroppedIssue }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCValueIsDroppedIssue >> displayText [
	| stream |
	stream := BlTextStream new.
	stream
		nextPutAll: rhs productionSymbol name;
		nextPutAll: ' : '.
	1
		to: rhs size
		do: [ :i | 
			(i == problemIndex
				ifTrue: [ stream next highlight: BrGlamorousColors textHighlightColor ]
				ifFalse: [ stream next ]) print: (rhs at: i) name.
			stream space ].
	^ stream contents
]
