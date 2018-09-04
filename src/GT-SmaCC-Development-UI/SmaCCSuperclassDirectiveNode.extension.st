Extension { #name : #SmaCCSuperclassDirectiveNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSuperclassDirectiveNode >> directiveNameToken [
	^ hierarchyToken
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSuperclassDirectiveNode >> displayString [
	^ '%' , hierarchyToken value , ' ' , superclass value
]
