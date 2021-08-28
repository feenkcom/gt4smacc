Extension { #name : 'SmaCCClassProductionExpressionNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> nodeName [
	^ classname isNil
		ifTrue: [ (self nodeOfType: SmaCCProductionRuleNode) nodeName ]
		ifFalse: [ classname value ]
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> originalAstNodeName [
	^ classname isNil
		ifTrue: [ '' ]
		ifFalse: [ classname value ]
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCClassProductionExpressionNode >> styledProductionLabel [
	| text |
	text := super styledProductionLabel.
	^ text copyFrom: 1 to: left startPosition - self startPosition
]
