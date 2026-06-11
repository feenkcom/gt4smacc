Class {
	#name : #GtSmaCCTransformationExampleCallNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'call',
		'period'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitCall: self
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> call [
	^ call
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> call: aGtSmaCCTransformationExampleCallExpressionNode [
	self call notNil ifTrue: [ self call parent: nil ].
	call := aGtSmaCCTransformationExampleCallExpressionNode.
	self call notNil ifTrue: [ self call parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> nodeVariables [
	^ #(#call)
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> period [
	^ period
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> period: aSmaCCToken [
	period := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleCallNode >> tokenVariables [
	^ #(#period)
]
