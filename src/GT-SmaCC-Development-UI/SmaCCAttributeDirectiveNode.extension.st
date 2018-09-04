Extension { #name : #SmaCCAttributeDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAttributeDirectiveNode >> directiveNameToken [
	^ attributesToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCAttributeDirectiveNode >> displayString [
	^ '%' , attributesToken value
]
