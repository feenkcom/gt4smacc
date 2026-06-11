Class {
	#name : #GtSmaCCTransformationExampleAssignmentNode,
	#superclass : #GtSmaCCTransformationExampleStatementNode,
	#instVars : [
		'variable',
		'assignmentToken',
		'value',
		'period'
	],
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> acceptVisitor: aProgramVisitor [
	^ aProgramVisitor visitAssignment: self
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> assignmentToken [
	^ assignmentToken
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> assignmentToken: aSmaCCToken [
	assignmentToken := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> nodeVariables [
	^ #(#variable #value)
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> period [
	^ period
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> period: aSmaCCToken [
	period := aSmaCCToken
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> tokenVariables [
	^ #(#assignmentToken #period)
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> value [
	^ value
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> value: aGtSmaCCTransformationExampleExpressionNode [
	self value notNil ifTrue: [ self value parent: nil ].
	value := aGtSmaCCTransformationExampleExpressionNode.
	self value notNil ifTrue: [ self value parent: self ]
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> variable [
	^ variable
]

{ #category : #generated }
GtSmaCCTransformationExampleAssignmentNode >> variable: aGtSmaCCTransformationExampleVariableNode [
	self variable notNil ifTrue: [ self variable parent: nil ].
	variable := aGtSmaCCTransformationExampleVariableNode.
	self variable notNil ifTrue: [ self variable parent: self ]
]
