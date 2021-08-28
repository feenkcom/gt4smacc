Extension { #name : 'SmaCCAssociativeDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCAssociativeDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCAssociativeDirectiveNode >> displayString [
	^ '%' , typeToken value
]
