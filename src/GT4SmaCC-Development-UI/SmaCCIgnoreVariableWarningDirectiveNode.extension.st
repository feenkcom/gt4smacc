Extension { #name : #SmaCCIgnoreVariableWarningDirectiveNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCIgnoreVariableWarningDirectiveNode >> directiveNameToken [
	^ ignoreVariableWarningToken
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCIgnoreVariableWarningDirectiveNode >> displayString [
	^ '%' , ignoreVariableWarningToken value
]
