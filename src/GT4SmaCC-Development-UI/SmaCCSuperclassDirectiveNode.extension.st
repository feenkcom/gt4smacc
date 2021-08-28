Extension { #name : 'SmaCCSuperclassDirectiveNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCSuperclassDirectiveNode >> directiveNameToken [
	^ hierarchyToken
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCSuperclassDirectiveNode >> displayString [
	^ '%' , hierarchyToken value , ' ' , superclass value
]
