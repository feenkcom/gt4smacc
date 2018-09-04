Extension { #name : #SmaCCFlagDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCFlagDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCFlagDirectiveNode >> displayString [
	^ '%' , typeToken value
]
