Extension { #name : 'SmaCCIgnoreVariableDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCIgnoreVariableDirectiveNode >> directiveNameToken [
	^ ignoreVariablesToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCIgnoreVariableDirectiveNode >> displayString [
	^ '%' , ignoreVariablesToken value
]
