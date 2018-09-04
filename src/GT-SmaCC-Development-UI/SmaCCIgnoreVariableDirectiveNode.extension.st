Extension { #name : #SmaCCIgnoreVariableDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCIgnoreVariableDirectiveNode >> directiveNameToken [
	^ ignoreVariablesToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCIgnoreVariableDirectiveNode >> displayString [
	^ '%' , ignoreVariablesToken value
]
