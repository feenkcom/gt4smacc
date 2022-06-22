Extension { #name : #SmaCCProductionRuleNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> displayString [
	^ name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> nodeName [
	^ String
		streamContents: [ :stream | 
			| nextIsUppercase |
			nextIsUppercase := true.
			name source
				do: [ :each | 
					each = $_
						ifTrue: [ nextIsUppercase := true ]
						ifFalse: [ stream
								nextPut:
									(nextIsUppercase
										ifTrue: [ each asUppercase ]
										ifFalse: [ each ]).
							nextIsUppercase := false ] ] ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> ruleReferences [
	^ self ruleReferencesTo: self name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> tags [
	| hasClass noClass code tags |
	hasClass := noClass := code := false.
	self expressions
		do: [ :each | 
			(each isKindOf: SmaCCClassProductionExpressionNode)
				ifTrue: [ hasClass := true ]
				ifFalse: [ (each isKindOf: SmaCCCodeProductionExpressionNode)
						ifTrue: [ code := true ]
						ifFalse: [ noClass := true ] ] ].
	tags := OrderedCollection new.
	hasClass
		ifTrue: [ tags add: 'AST' ].
	code
		ifTrue: [ tags add: 'Expression' ].
	noClass
		ifTrue: [ tags add: 'Default' ].
	^ tags asArray
]
