Extension { #name : #SmaCCTokenRuleNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> displayString [
	^ name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> isMethod [
	^ (self scannerClass whichClassIncludesSelector: self selector)
		ifNil: [ false ]
		ifNotNil: [ :cls | cls includesBehavior: SmaCCScanner ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> ruleReferences [
	^ self ruleReferencesTo: self name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> selector [
	^ (self name value copyFrom: 2 to: self name value size - 1) asSymbol
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> tags [
	^ self isMethod
		ifTrue: [ #('Token' 'Method') ]
		ifFalse: [ #('Token') ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> testTokensDo: aBlock [
	aBlock value: name
]
