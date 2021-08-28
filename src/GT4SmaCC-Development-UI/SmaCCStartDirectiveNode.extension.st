Extension { #name : 'SmaCCStartDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCStartDirectiveNode >> directiveNameToken [
	^ startToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCStartDirectiveNode >> displayString [
	^ '%' , startToken value
]
