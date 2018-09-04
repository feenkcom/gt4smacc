Extension { #name : #SmaCCStartDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCStartDirectiveNode >> directiveNameToken [
	^ startToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCStartDirectiveNode >> displayString [
	^ '%' , startToken value
]
