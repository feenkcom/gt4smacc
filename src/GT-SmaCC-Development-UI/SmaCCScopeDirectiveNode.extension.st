Extension { #name : #SmaCCScopeDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCScopeDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCScopeDirectiveNode >> displayString [
	^ '%' , typeToken value
]
