Extension { #name : #SmaCCCodeProductionExpressionNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCCodeProductionExpressionNode >> styledProductionLabel [
	| text |
	text := super styledProductionLabel.
	^ text copyFrom: 1 to: code startPosition - self startPosition
]
