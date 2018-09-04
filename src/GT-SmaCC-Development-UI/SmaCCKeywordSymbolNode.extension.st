Extension { #name : #SmaCCKeywordSymbolNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> buildInterfaceIn: presentation [
	self buildVariableNameInterfaceFor: self name value in: presentation.
	presentation list
		title: 'References';
		display: [ self ruleReferencesTo: self name value ];
		format: [ :e | e displayString ];
		tags: [ :e | e tags ]
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> displayString [
	^ self name value
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCKeywordSymbolNode >> matches: aString [
	^ (self name value asLowercase indexOfSubCollection: aString asLowercase) > 0
]
