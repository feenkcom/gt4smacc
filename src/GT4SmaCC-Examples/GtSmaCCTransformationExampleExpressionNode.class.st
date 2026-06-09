Class {
	#name : #GtSmaCCTransformationExampleExpressionNode,
	#superclass : #GtSmaCCTransformationExampleProgramNode,
	#instVars : [
		'leftParens',
		'rightParens'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitExpression: self
]

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> compositeTokenVariables [
	^ #(#leftParens #rightParens)
]

{ #category : #'generated-initialize-release' }
GtSmaCCTransformationExampleExpressionNode >> initialize [
	super initialize.
	leftParens := OrderedCollection new: 2.
	rightParens := OrderedCollection new: 2.
]

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> leftParens [
	^ leftParens
]

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> leftParens: anOrderedCollection [
	leftParens := anOrderedCollection
]

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> rightParens [
	^ rightParens
]

{ #category : #generated }
GtSmaCCTransformationExampleExpressionNode >> rightParens: anOrderedCollection [
	rightParens := anOrderedCollection
]
