Extension { #name : #SmaCCClassProductionExpressionNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> originalAstNodeName [
	^ classname isNil
		ifTrue: [ '' ]
		ifFalse: [ classname value ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> styledProductionLabel [
	| text |
	text := super styledProductionLabel.
	^ text copyFrom: 1 to: left startPosition - self startPosition
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> updateSource: aSmaCCString [
	self hasNodeDefined
		ifTrue: [ self astNodeName = self originalAstNodeName
				ifFalse: [ classname isNil
						ifFalse: [ aSmaCCString deleteFrom: classname startPosition to: classname stopPosition ].
					aSmaCCString insert: self astNodeName at: right startPosition ] ]
		ifFalse: [ aSmaCCString deleteFrom: left startPosition to: right stopPosition ]
]
