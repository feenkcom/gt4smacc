Class {
	#name : #GtSmaCCProductionRule,
	#superclass : #GtSmaCCGrammarItem,
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #testing }
GtSmaCCProductionRule >> hasASTNode [
	^ self ast expressions
		anySatisfy: [ :each | each class = SmaCCClassProductionExpressionNode ]
]

{ #category : #testing }
GtSmaCCProductionRule >> hasCodeExpression [
	^ self ast expressions
		anySatisfy: [ :each | each class = SmaCCCodeProductionExpressionNode ]
]

{ #category : #testing }
GtSmaCCProductionRule >> hasOnlyDefaultReduceExpressions [
	^ (self hasASTNode or: [ self hasCodeExpression ]) not
]

{ #category : #testing }
GtSmaCCProductionRule >> hasOnlySingleItemProductions [
	^ self ast expressions allSatisfy: [ :each | each terms size <= 1 ]
]

{ #category : #testing }
GtSmaCCProductionRule >> isProductionRule [
	^ true
]

{ #category : #private }
GtSmaCCProductionRule >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForProductionRule
]
