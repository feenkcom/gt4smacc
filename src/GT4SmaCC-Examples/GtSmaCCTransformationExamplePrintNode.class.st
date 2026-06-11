Class {
	#name : #GtSmaCCTransformationExamplePrintNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'printToken',
		'value',
		'period'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitPrint: self
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> nodeVariables [
	^ #(#value)
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> period [
	^ period
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> period: aSmaCCToken [
	period := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> printToken [
	^ printToken
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> printToken: aSmaCCToken [
	printToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> tokenVariables [
	^ #(#printToken #period)
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> value [
	^ value
]

{ #category : #generated }
GtSmaCCTransformationExamplePrintNode >> value: aGtSmaCCTransformationExampleExpressionNode [
	self value notNil ifTrue: [ self value parent: nil ].
	value := aGtSmaCCTransformationExampleExpressionNode.
	self value notNil ifTrue: [ self value parent: self ]
]
