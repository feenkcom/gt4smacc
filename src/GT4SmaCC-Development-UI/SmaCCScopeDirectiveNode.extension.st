Extension { #name : 'SmaCCScopeDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCScopeDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCScopeDirectiveNode >> displayString [
	^ '%' , typeToken value
]
