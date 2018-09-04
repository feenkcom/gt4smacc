Extension { #name : #SmaCCNodeNameDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCNodeNameDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCNodeNameDirectiveNode >> displayString [
	^ '%' , typeToken value
]
