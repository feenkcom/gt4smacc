Extension { #name : #SmaCCDefinitionNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> defaultTextAttributes [
	^ GtSmaCCCoder defaultTextAttributes
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> matches: aString [
	^ (self source asLowercase indexOfSubCollection: aString asLowercase) > 0
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> scannerClass [
	^ self topParent attributeNamed: #scannerClass ifAbsent: [ SmaCCScanner ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> tags [
	^ #()
]
