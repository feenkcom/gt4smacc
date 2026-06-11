Class {
	#name : #GtSmaCCTransformationExampleInputNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'inputToken',
		'variable',
		'period'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitInput: self
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> inputToken [
	^ inputToken
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> inputToken: aSmaCCToken [
	inputToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> nodeVariables [
	^ #(#variable)
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> period [
	^ period
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> period: aSmaCCToken [
	period := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> tokenVariables [
	^ #(#inputToken #period)
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> variable [
	^ variable
]

{ #category : #generated }
GtSmaCCTransformationExampleInputNode >> variable: aGtSmaCCTransformationExampleVariableNode [
	self variable notNil ifTrue: [ self variable parent: nil ].
	variable := aGtSmaCCTransformationExampleVariableNode.
	self variable notNil ifTrue: [ self variable parent: self ]
]
