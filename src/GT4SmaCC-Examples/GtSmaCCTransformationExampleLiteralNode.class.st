Class {
	#name : #GtSmaCCTransformationExampleLiteralNode,
	#superclass : #GtSmaCCTransformationExampleExpressionNode,
	#instVars : [
		'value'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleLiteralNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitLiteral: self
]

{ #category : #generated }
GtSmaCCTransformationExampleLiteralNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
GtSmaCCTransformationExampleLiteralNode >> value [
	^ value
]

{ #category : #generated }
GtSmaCCTransformationExampleLiteralNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
