Extension { #name : #SmaCCAssociativeDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAssociativeDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAssociativeDirectiveNode >> displayString [
	^ '%' , typeToken value
]
