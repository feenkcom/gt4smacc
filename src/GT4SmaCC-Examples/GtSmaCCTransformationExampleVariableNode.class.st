Class {
	#name : #GtSmaCCTransformationExampleVariableNode,
	#superclass : #GtSmaCCTransformationExampleExpressionNode,
	#instVars : [
		'name'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleVariableNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitVariable: self
]

{ #category : #generated }
GtSmaCCTransformationExampleVariableNode >> name [
	^ name
]

{ #category : #generated }
GtSmaCCTransformationExampleVariableNode >> name: aSmaCCToken [
	name := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleVariableNode >> tokenVariables [
	^ #(#name)
]
