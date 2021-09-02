Class {
	#name : 'GtSmaCCProductionRule',
	#superclass : 'GtSmaCCGrammarItem',
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : 'testing' }
GtSmaCCProductionRule >> hasASTExpression [
	^ self ast expressions
		anySatisfy: [ :each | each class = SmaCCClassProductionExpressionNode ]
]

{ #category : 'testing' }
GtSmaCCProductionRule >> hasCodeExpression [
	^ self ast expressions
		anySatisfy: [ :each | each class = SmaCCCodeProductionExpressionNode ]
]

{ #category : 'testing' }
GtSmaCCProductionRule >> hasDefaultExpression [
	^ self ast expressions
		anySatisfy: [ :each | each class = SmaCCProductionExpressionNode ]
]

{ #category : 'testing' }
GtSmaCCProductionRule >> hasOnlyDefaultReduceExpressions [
	^ (self hasASTExpression or: [ self hasCodeExpression ]) not
]

{ #category : 'testing' }
GtSmaCCProductionRule >> hasOnlySingleItemProductions [
	^ self ast expressions allSatisfy: [ :each | each terms size <= 1 ]
]

{ #category : 'testing' }
GtSmaCCProductionRule >> isProductionRule [
	^ true
]

{ #category : 'accessing' }
GtSmaCCProductionRule >> isReferenced [
	^ super isReferenced or: [ self isStartingProduction ]
]

{ #category : 'accessing' }
GtSmaCCProductionRule >> isStartingProduction [
	^ self grammar startingProductions includes: self
]

{ #category : 'private' }
GtSmaCCProductionRule >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForProductionRule
]
