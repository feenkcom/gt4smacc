Class {
	#name : #GtSmaCCTransformationExampleReturnNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'returnToken',
		'value',
		'period'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitReturn: self
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> nodeVariables [
	^ #(#value)
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> period [
	^ period
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> period: aSmaCCToken [
	period := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> returnToken [
	^ returnToken
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> returnToken: aSmaCCToken [
	returnToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> tokenVariables [
	^ #(#returnToken #period)
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> value [
	^ value
]

{ #category : #generated }
GtSmaCCTransformationExampleReturnNode >> value: aGtSmaCCTransformationExampleExpressionNode [
	self value notNil ifTrue: [ self value parent: nil ].
	value := aGtSmaCCTransformationExampleExpressionNode.
	self value notNil ifTrue: [ self value parent: self ]
]
