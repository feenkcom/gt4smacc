Extension { #name : #SmaCCKeywordSymbolNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> displayString [
	^ self name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> matches: aString [
	^ (self name value asLowercase indexOfSubCollection: aString asLowercase) > 0
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> tags [
	^ #('Token')
]
