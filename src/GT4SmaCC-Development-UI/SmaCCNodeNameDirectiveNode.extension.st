Extension { #name : #SmaCCNodeNameDirectiveNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCNodeNameDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCNodeNameDirectiveNode >> displayString [
	^ '%' , typeToken value
]
