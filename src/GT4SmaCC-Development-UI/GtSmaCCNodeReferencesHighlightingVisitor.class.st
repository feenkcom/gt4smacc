Class {
	#name : #GtSmaCCNodeReferencesHighlightingVisitor,
	#superclass : #GtSmaCCReferencesHighlightingVisitor,
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : #generated }
GtSmaCCNodeReferencesHighlightingVisitor >> visitClassProductionExpression: aClassProductionExpression [
	aClassProductionExpression nodeName = name
		ifTrue: [ self
				highlightFrom: aClassProductionExpression left startPosition
				to: aClassProductionExpression right stopPosition ].
	super visitClassProductionExpression: aClassProductionExpression
]
