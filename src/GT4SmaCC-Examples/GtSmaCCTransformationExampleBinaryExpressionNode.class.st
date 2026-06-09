Class {
	#name : #GtSmaCCTransformationExampleBinaryExpressionNode,
	#superclass : #GtSmaCCTransformationExampleExpressionNode,
	#instVars : [
		'left',
		'operator',
		'right'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitBinaryExpression: self
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> left [
	^ left
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> left: aGtSmaCCTransformationExampleExpressionNode [
	self left notNil ifTrue: [ self left parent: nil ].
	left := aGtSmaCCTransformationExampleExpressionNode.
	self left notNil ifTrue: [ self left parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> nodeVariables [
	^ #(#left #right)
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> operator [
	^ operator
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> operator: aSmaCCToken [
	operator := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> right [
	^ right
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> right: aGtSmaCCTransformationExampleExpressionNode [
	self right notNil ifTrue: [ self right parent: nil ].
	right := aGtSmaCCTransformationExampleExpressionNode.
	self right notNil ifTrue: [ self right parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleBinaryExpressionNode >> tokenVariables [
	^ #(#operator)
]
