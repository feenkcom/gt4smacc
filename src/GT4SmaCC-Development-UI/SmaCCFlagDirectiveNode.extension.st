Extension { #name : #SmaCCFlagDirectiveNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCFlagDirectiveNode >> directiveNameToken [
	^ typeToken
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCFlagDirectiveNode >> displayString [
	^ '%' , typeToken value
]
