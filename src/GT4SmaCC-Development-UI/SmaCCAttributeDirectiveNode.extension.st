Extension { #name : 'SmaCCAttributeDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCAttributeDirectiveNode >> directiveNameToken [
	^ attributesToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCAttributeDirectiveNode >> displayString [
	^ '%' , attributesToken value
]
